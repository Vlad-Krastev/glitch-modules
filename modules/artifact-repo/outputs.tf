output "id" {
  description = "Repository resource ID."
  value       = google_artifact_registry_repository.this.id
}

output "url" {
  description = "Docker host/path to push to and pull from, e.g. europe-west3-docker.pkg.dev/PROJECT/REPO."
  value       = "${var.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.this.repository_id}"
}

output "kms_key" {
  description = "Autokey CMEK key protecting the repository."
  value       = google_kms_key_handle.this.kms_key
}
