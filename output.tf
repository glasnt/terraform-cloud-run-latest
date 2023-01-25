output "service_url" {
  description = "Cloud Run service URL"
  value = google_cloud_run_service.server.status[0].url
}