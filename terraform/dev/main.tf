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
  project = var.project_id
  region  = var.region
}

module "iam" {
  source = "../modules/iam"

  project_id  = var.project_id
  github_repo = var.github_repo

  roles = [
    "roles/aiplatform.user",
    "roles/discoveryengine.viewer",
    "roles/discoveryengine.editor",
  ]
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

module "atlantis" {
  source = "../modules/atlantis"

  project_id            = var.project_id
  region                = var.region
  network               = module.networking.network_name
  subnetwork            = module.networking.subnet_name
  atlantis_domain       = var.atlantis_domain
  github_user           = var.github_user
  github_repo_allowlist = "github.com/${var.github_repo}"

  depends_on = [module.networking]
}

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
