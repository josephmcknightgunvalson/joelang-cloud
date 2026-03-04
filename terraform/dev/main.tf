terraform {
  required_version = ">= 1.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.14"
    }
  }
}

provider "google" {
  project                     = var.project_id
  region                      = var.region
  impersonate_service_account = "joelang-tf@joelang-dev.iam.gserviceaccount.com"
}

module "iam" {
  source = "../modules/iam"

  project_id                   = var.project_id
  service_account_id           = "joelang-local-dev"
  service_account_display_name = "JoeLang Local Development"
  description                  = "Service account for local development access"
  enable_workload_identity     = true
  github_repo                  = var.github_repo

  roles = [
    "roles/aiplatform.user",
    "roles/discoveryengine.viewer",
    "roles/discoveryengine.editor",
  ]
}

module "iam_terraform" {
  source = "../modules/iam"

  project_id                   = var.project_id
  service_account_id           = "joelang-tf"
  service_account_display_name = "JoeLang Terraform"
  description                  = "Service account for Terraform automation"

  roles = [
    "roles/compute.admin",
    "roles/storage.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iam.workloadIdentityPoolAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/secretmanager.admin",
    "roles/discoveryengine.admin",
    "roles/vpcaccess.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/servicenetworking.networksAdmin",
    "roles/aiplatform.admin",
  ]
}

# GCS bucket for remote Terraform state

resource "google_project_service" "storage" {
  project            = var.project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "google_storage_bucket" "terraform_state" {
  project                     = var.project_id
  name                        = "joelang-tf"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = false

  versioning {
    enabled = true
  }

  depends_on = [google_project_service.storage]
}

module "vertex" {
  source = "../modules/vertex"

  project_id             = var.project_id
  region                 = var.region
  vertex_search_location = var.vertex_search_location
  data_store_id          = var.data_store_id
  search_engine_id       = var.search_engine_id
}

module "networking" {
  source = "../modules/networking"

  project_id = var.project_id
  region     = var.region
}

# TODO: Create joelang-atlantis GitHub user and populate secrets before enabling
# Requires: atlantis-github-token and atlantis-webhook-secret in Secret Manager
# module "atlantis" {
#   source = "../modules/atlantis"
#
#   project_id            = var.project_id
#   region                = var.region
#   network               = module.networking.network_name
#   subnetwork            = module.networking.subnet_name
#   atlantis_domain       = var.atlantis_domain
#   github_user           = var.github_user
#   github_repo_allowlist = "github.com/${var.github_repo}"
#
#   depends_on = [module.networking]
# }

# module "cloud_armor" {
#   source = "../modules/cloud-armor"
#
#   project_id = var.project_id
# }

# module "postgres" {
#   source = "../modules/postgres"
#
#   project_id          = var.project_id
#   region              = var.region
#   deletion_protection = false
#   backup_enabled      = false
#   ipv4_enabled        = false
#   private_network     = module.networking.network_id
#
#   depends_on = [module.networking]
# }
