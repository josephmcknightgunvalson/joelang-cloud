variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "service_account_id" {
  description = "ID for the service account"
  type        = string
}

variable "service_account_display_name" {
  description = "Display name for the service account"
  type        = string
}

variable "description" {
  description = "Description for the service account"
  type        = string
  default     = ""
}

variable "roles" {
  description = "IAM roles to bind to the service account"
  type        = list(string)
}

variable "enable_workload_identity" {
  description = "Whether to create workload identity pool and provider for GitHub Actions"
  type        = bool
  default     = false
}

variable "github_repo" {
  description = "GitHub repository (owner/repo) for workload identity federation"
  type        = string
  default     = ""
}

variable "workload_identity_pool_id" {
  description = "ID for the workload identity pool"
  type        = string
  default     = "github-actions-pool"
}
