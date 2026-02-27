variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
}

variable "zone" {
  description = "GCP zone for the compute instance"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Name for the Atlantis compute instance"
  type        = string
  default     = "joelang-atlantis"
}

variable "machine_type" {
  description = "Machine type for the Atlantis instance"
  type        = string
  default     = "e2-micro"
}

variable "network" {
  description = "VPC network name or self-link"
  type        = string
}

variable "subnetwork" {
  description = "Subnet name or self-link for the instance"
  type        = string
}

variable "atlantis_image" {
  description = "Docker image for Atlantis"
  type        = string
  default     = "ghcr.io/runatlantis/atlantis:latest"
}

variable "atlantis_port" {
  description = "Port Atlantis listens on inside the container"
  type        = number
  default     = 4141
}

variable "atlantis_domain" {
  description = "Domain name for Atlantis (used by Caddy for TLS)"
  type        = string
}

variable "github_user" {
  description = "GitHub username for Atlantis"
  type        = string
}

variable "github_repo_allowlist" {
  description = "GitHub repo allowlist for Atlantis (e.g. github.com/org/repo)"
  type        = string
}

variable "github_token_secret_id" {
  description = "Secret Manager secret ID for the GitHub token"
  type        = string
  default     = "atlantis-github-token"
}

variable "github_webhook_secret_id" {
  description = "Secret Manager secret ID for the GitHub webhook secret"
  type        = string
  default     = "atlantis-webhook-secret"
}

variable "service_account_id" {
  description = "ID for the Atlantis service account"
  type        = string
  default     = "joelang-atlantis"
}

variable "state_bucket_name" {
  description = "Name for the GCS bucket storing Terraform state"
  type        = string
  default     = "joelang-terraform-state"
}

variable "state_bucket_location" {
  description = "Location for the GCS state bucket"
  type        = string
  default     = "US"
}

variable "service_account_roles" {
  description = "IAM roles to grant the Atlantis service account"
  type        = list(string)
  default = [
    "roles/editor",
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.workloadIdentityPoolAdmin",
    "roles/storage.admin",
  ]
}
