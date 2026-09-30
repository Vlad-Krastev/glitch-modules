output "name" {
  description = "Service name (for Firebase Hosting rewrites: serviceId)."
  value       = google_cloud_run_v2_service.this.name
}

output "uri" {
  description = "Default run.app URL."
  value       = google_cloud_run_v2_service.this.uri
}

output "service_account" {
  description = "Email of the service's dedicated service account."
  value       = google_service_account.this.email
}

output "service_account_member" {
  description = "IAM member string of the service account (serviceAccount:...)."
  value       = google_service_account.this.member
}
