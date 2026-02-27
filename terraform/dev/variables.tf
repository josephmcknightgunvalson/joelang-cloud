variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "vertex_search_location" {
  description = "Location for Vertex AI Search resources"
  type        = string
  default     = "global"
}

variable "data_store_id" {
  description = "ID for the Discovery Engine data store"
  type        = string
  default     = "joelang-knowledge-base"
}

variable "search_engine_id" {
  description = "ID for the Discovery Engine search engine"
  type        = string
  default     = "joelang-search"
}

variable "github_repo" {
  description = "GitHub repository (owner/repo) for workload identity federation"
  type        = string
}
