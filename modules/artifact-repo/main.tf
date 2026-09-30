# CMEK via Autokey: the key is created on demand in the folder's key project, and Autokey grants
# the Artifact Registry service agent access to it (org policy requires CMEK for AR).
resource "google_kms_key_handle" "this" {
  project                = var.project_id
  name                   = "ar-${var.repository_id}"
  location               = var.location
  resource_type_selector = "artifactregistry.googleapis.com/Repository"
}

resource "google_artifact_registry_repository" "this" {
  project       = var.project_id
  location      = var.location
  repository_id = var.repository_id
  description   = var.description
  format        = "DOCKER"
  kms_key_name  = google_kms_key_handle.this.kms_key
  labels        = var.labels

  docker_config {
    immutable_tags = true # a tag always means the same image
  }

  # Storage is billed per GB: keep the last N tagged versions and drop untagged layers quickly.
  cleanup_policy_dry_run = false

  cleanup_policies {
    id     = "keep-recent"
    action = "KEEP"
    most_recent_versions {
      keep_count = var.keep_recent
    }
  }

  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"
    condition {
      tag_state  = "UNTAGGED"
      older_than = "86400s" # 1 day
    }
  }

  cleanup_policies {
    id     = "delete-old"
    action = "DELETE"
    condition {
      tag_state  = "ANY"
      older_than = "2592000s" # 30 days — KEEP above wins for the most recent versions
    }
  }
}

resource "google_artifact_registry_repository_iam_member" "reader" {
  for_each = toset(var.readers)

  project    = var.project_id
  location   = var.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.reader"
  member     = each.value
}

resource "google_artifact_registry_repository_iam_member" "writer" {
  for_each = toset(var.writers)

  project    = var.project_id
  location   = var.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.writer"
  member     = each.value
}
