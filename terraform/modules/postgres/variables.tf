variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for the Cloud SQL instance"
  type        = string
}

variable "instance_name" {
  description = "Name for the Cloud SQL instance"
  type        = string
  default     = "joelang-db"
}

variable "database_name" {
  description = "Name for the application database"
  type        = string
  default     = "joelang"
}

variable "database_user" {
  description = "Name for the database user"
  type        = string
  default     = "joelang"
}

variable "tier" {
  description = "Machine tier for the Cloud SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = false
}

variable "backup_enabled" {
  description = "Whether to enable automated backups"
  type        = bool
  default     = false
}

variable "authorized_networks" {
  description = "List of authorized networks for database access"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "ipv4_enabled" {
  description = "Whether to assign a public IPv4 address to the instance"
  type        = bool
  default     = false
}

variable "private_network" {
  description = "VPC network ID for private IP access"
  type        = string
  default     = null
}
