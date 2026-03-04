variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "policy_name" {
  description = "Name for the Cloud Armor security policy"
  type        = string
  default     = "joelang-waf"
}

variable "rate_limit_threshold" {
  description = "Maximum requests per interval before rate limiting"
  type        = number
  default     = 100
}

variable "rate_limit_interval" {
  description = "Rate limiting interval in seconds"
  type        = number
  default     = 60
}
