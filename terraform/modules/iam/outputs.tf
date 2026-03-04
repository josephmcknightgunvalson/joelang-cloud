output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.this.email
}

output "workload_identity_provider" {
  description = "Full resource name of the workload identity provider for GitHub Actions auth"
  value       = var.enable_workload_identity ? google_iam_workload_identity_pool_provider.github[0].name : null
}
