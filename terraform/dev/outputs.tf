output "service_account_email" {
  description = "Service account email for local development"
  value       = module.iam.service_account_email
}

output "workload_identity_provider" {
  description = "Workload identity provider resource name for GitHub Actions"
  value       = module.iam.workload_identity_provider
}

output "data_store_name" {
  description = "Full resource name of the Discovery Engine data store"
  value       = module.vertex.data_store_name
}

output "search_engine_name" {
  description = "Full resource name of the Discovery Engine search engine"
  value       = module.vertex.search_engine_name
}

output "gemini_endpoint" {
  description = "Vertex AI Gemini API endpoint URL"
  value       = module.vertex.gemini_endpoint
}

output "auth_instructions" {
  description = "Instructions for authenticating locally"
  value       = <<-EOT
    To authenticate for local development:

    1. Login with your Google account:
       gcloud auth application-default login --impersonate-service-account=${module.iam.service_account_email}

    2. Verify authentication:
       gcloud auth application-default print-access-token

    3. Set your project:
       gcloud config set project ${var.project_id}
  EOT
}

# output "db_instance_connection_name" {
#   description = "Cloud SQL instance connection name"
#   value       = module.postgres.instance_connection_name
# }

# output "db_private_ip" {
#   description = "Cloud SQL private IP address"
#   value       = module.postgres.private_ip
# }

# output "db_password" {
#   description = "Database password"
#   value       = module.postgres.database_password
#   sensitive   = true
# }

# output "vpc_network_name" {
#   description = "Name of the VPC network"
#   value       = module.networking.network_name
# }

# output "vpc_connector_id" {
#   description = "ID of the VPC Access connector for Cloud Run"
#   value       = module.networking.vpc_connector_id
# }

# output "cloud_armor_policy" {
#   description = "Self link of the Cloud Armor WAF policy"
#   value       = module.cloud_armor.policy_self_link
# }
