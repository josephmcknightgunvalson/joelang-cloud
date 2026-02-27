output "instance_ip" {
  description = "Public IP address of the Atlantis instance (use for DNS A record)"
  value       = google_compute_address.atlantis.address
}

output "atlantis_url" {
  description = "URL for the Atlantis web interface"
  value       = "https://${var.atlantis_domain}"
}

output "service_account_email" {
  description = "Email of the Atlantis service account"
  value       = google_service_account.atlantis.email
}

output "state_bucket_name" {
  description = "Name of the GCS bucket for Terraform state"
  value       = google_storage_bucket.terraform_state.name
}

output "state_bucket_url" {
  description = "URL of the GCS bucket for Terraform state"
  value       = google_storage_bucket.terraform_state.url
}
