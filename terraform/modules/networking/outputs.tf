output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.this.id
}

output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.this.name
}

output "subnet_id" {
  description = "ID of the regional subnet"
  value       = google_compute_subnetwork.this.id
}

output "vpc_connector_id" {
  description = "ID of the VPC Access connector"
  value       = google_vpc_access_connector.this.id
}
