variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region for networking resources"
  type        = string
}

variable "network_name" {
  description = "Name for the VPC network"
  type        = string
  default     = "joelang-vpc"
}

variable "subnet_cidr" {
  description = "CIDR range for the regional subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "psa_range_prefix_length" {
  description = "Prefix length for the Private Service Access IP range"
  type        = number
  default     = 16
}

variable "connector_machine_type" {
  description = "Machine type for the VPC Access connector"
  type        = string
  default     = "e2-micro"
}

variable "connector_min_instances" {
  description = "Minimum instances for the VPC Access connector"
  type        = number
  default     = 2
}

variable "connector_max_instances" {
  description = "Maximum instances for the VPC Access connector"
  type        = number
  default     = 3
}

variable "connector_cidr" {
  description = "CIDR range for the VPC Access connector"
  type        = string
  default     = "10.0.1.0/28"
}
