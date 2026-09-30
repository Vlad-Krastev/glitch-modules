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
  value       = local.service_account
}

output "service_account_member" {
  description = "IAM member string of the service account (serviceAccount:...)."
  value       = "serviceAccount:${local.service_account}"
}
