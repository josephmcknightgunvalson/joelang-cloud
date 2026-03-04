output "data_store_name" {
  description = "Full resource name of the Discovery Engine data store"
  value       = google_discovery_engine_data_store.knowledge_base.name
}

output "search_engine_name" {
  description = "Full resource name of the Discovery Engine search engine"
  value       = google_discovery_engine_search_engine.search.name
}

output "gemini_endpoint" {
  description = "Vertex AI Gemini API endpoint URL"
  value       = "https://${var.region}-aiplatform.googleapis.com/v1/projects/${var.project_id}/locations/${var.region}/publishers/google/models/gemini-2.0-flash:generateContent"
}
