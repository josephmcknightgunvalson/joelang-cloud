output "instance_name" {
  description = "Name of the Cloud SQL instance"
  value       = google_sql_database_instance.this.name
}

output "instance_connection_name" {
  description = "Connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.this.connection_name
}

output "public_ip" {
  description = "Public IP address of the Cloud SQL instance"
  value       = google_sql_database_instance.this.public_ip_address
}

output "private_ip" {
  description = "Private IP address of the Cloud SQL instance"
  value       = google_sql_database_instance.this.private_ip_address
}

output "database_name" {
  description = "Name of the application database"
  value       = google_sql_database.this.name
}

output "database_user" {
  description = "Name of the database user"
  value       = google_sql_user.this.name
}

output "database_password" {
  description = "Password for the database user"
  value       = random_password.db.result
  sensitive   = true
}
