terraform {
  required_version = ">= 1.14"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.14"
    }
  }
}

resource "google_project_service" "aiplatform" {
  project            = var.project_id
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "discoveryengine" {
  project            = var.project_id
  service            = "discoveryengine.googleapis.com"
  disable_on_destroy = false
}

resource "google_discovery_engine_data_store" "knowledge_base" {
  location          = var.vertex_search_location
  data_store_id     = var.data_store_id
  display_name      = "JoeLang Knowledge Base"
  industry_vertical = "GENERIC"
  content_config    = "CONTENT_REQUIRED"
  solution_types    = ["SOLUTION_TYPE_SEARCH"]

  document_processing_config {
    default_parsing_config {
      digital_parsing_config {}
    }
  }

  depends_on = [google_project_service.discoveryengine]
}

resource "google_discovery_engine_search_engine" "search" {
  engine_id     = var.search_engine_id
  collection_id = "default_collection"
  location      = var.vertex_search_location
  display_name  = "JoeLang Search"

  data_store_ids = [google_discovery_engine_data_store.knowledge_base.data_store_id]

  search_engine_config {
    search_tier    = "SEARCH_TIER_STANDARD"
    search_add_ons = ["SEARCH_ADD_ON_LLM"]
  }

  depends_on = [google_discovery_engine_data_store.knowledge_base]
}
