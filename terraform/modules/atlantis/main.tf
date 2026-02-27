terraform {
  required_version = ">= 1.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.14"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

# Fetch GitHub webhook IP ranges dynamically so firewall rules stay current
data "http" "github_meta" {
  url = "https://api.github.com/meta"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  github_hooks_ipv4 = [
    for cidr in jsondecode(data.http.github_meta.response_body).hooks :
    cidr if can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", cidr))
  ]
}

resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "secretmanager" {
  project            = var.project_id
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage" {
  project            = var.project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

# Service account for Atlantis

resource "google_service_account" "atlantis" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "Atlantis Terraform Automation"

  depends_on = [google_project_service.iam]
}

resource "google_project_iam_member" "atlantis_roles" {
  for_each = toset(var.service_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.atlantis.email}"
}

# GCS bucket for remote Terraform state

resource "google_storage_bucket" "terraform_state" {
  project                     = var.project_id
  name                        = var.state_bucket_name
  location                    = var.state_bucket_location
  uniform_bucket_level_access = true
  force_destroy               = false

  versioning {
    enabled = true
  }

  depends_on = [google_project_service.storage]
}

# Static external IP for the Atlantis instance

resource "google_compute_address" "atlantis" {
  project = var.project_id
  name    = "${var.instance_name}-ip"
  region  = var.region

  depends_on = [google_project_service.compute]
}

# Firewall: allow HTTPS from GitHub webhook IPs

resource "google_compute_firewall" "atlantis_https" {
  project = var.project_id
  name    = "${var.instance_name}-allow-https"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = local.github_hooks_ipv4

  target_tags = ["atlantis"]
}

# Firewall: allow HTTP from GitHub webhook IPs (Let's Encrypt HTTP-01 redirect)

resource "google_compute_firewall" "atlantis_http" {
  project = var.project_id
  name    = "${var.instance_name}-allow-http"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = local.github_hooks_ipv4

  target_tags = ["atlantis"]
}

# Compute instance running COS with Caddy + Atlantis containers

resource "google_compute_instance" "atlantis" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["atlantis"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = var.subnetwork

    # trivy:ignore:GCP-0031 -- public IP required for GitHub webhook ingress
    access_config {
      nat_ip = google_compute_address.atlantis.address
    }
  }

  metadata = {
    startup-script = <<-SCRIPT
      #!/bin/bash
      set -euo pipefail

      # Fetch secrets from Secret Manager
      GITHUB_TOKEN=$(gcloud secrets versions access latest \
        --secret="${var.github_token_secret_id}" \
        --project="${var.project_id}")

      GITHUB_WEBHOOK_SECRET=$(gcloud secrets versions access latest \
        --secret="${var.github_webhook_secret_id}" \
        --project="${var.project_id}")

      # Write Caddyfile
      mkdir -p /etc/caddy
      cat > /etc/caddy/Caddyfile <<EOF
      ${var.atlantis_domain} {
        handle /events {
          @blocked not remote_ip ${join(" ", local.github_hooks_ipv4)}
          respond @blocked 403
          reverse_proxy atlantis:${var.atlantis_port}
        }
        respond 403
      }
      EOF

      # Clean up any existing containers (safe for reboots)
      docker rm -f atlantis caddy 2>/dev/null || true
      docker network rm atlantis-net 2>/dev/null || true

      # Create shared Docker network
      docker network create atlantis-net

      # Run Caddy reverse proxy
      docker run -d \
        --name caddy \
        --network atlantis-net \
        --restart unless-stopped \
        -p 80:80 \
        -p 443:443 \
        -v /etc/caddy/Caddyfile:/etc/caddy/Caddyfile:ro \
        -v caddy_data:/data \
        -v caddy_config:/config \
        caddy:latest

      # Run Atlantis
      docker run -d \
        --name atlantis \
        --network atlantis-net \
        --restart unless-stopped \
        ${var.atlantis_image} server \
        --atlantis-url="https://${var.atlantis_domain}" \
        --gh-user="${var.github_user}" \
        --gh-token="$$GITHUB_TOKEN" \
        --gh-webhook-secret="$$GITHUB_WEBHOOK_SECRET" \
        --repo-allowlist="${var.github_repo_allowlist}" \
        --port=${var.atlantis_port}
    SCRIPT
  }

  service_account {
    email  = google_service_account.atlantis.email
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true

  depends_on = [
    google_project_service.compute,
    google_secret_manager_secret_iam_member.github_token,
    google_secret_manager_secret_iam_member.webhook_secret,
  ]
}

# Grant Secret Manager access to the Atlantis service account

resource "google_secret_manager_secret_iam_member" "github_token" {
  project   = var.project_id
  secret_id = var.github_token_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.atlantis.email}"

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_iam_member" "webhook_secret" {
  project   = var.project_id
  secret_id = var.github_webhook_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.atlantis.email}"

  depends_on = [google_project_service.secretmanager]
}
