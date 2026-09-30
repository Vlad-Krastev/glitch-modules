locals {
  firebase = var.access == "firebase"
}

# Dedicated identity with no roles: grant what the app needs outside the module.
resource "google_service_account" "this" {
  project      = var.project_id
  account_id   = var.name
  display_name = "Cloud Run service ${var.name}"
}

# CMEK via Autokey (org policy requires CMEK for Cloud Run); Autokey grants the Cloud Run
# service agent access to the key.
resource "google_kms_key_handle" "this" {
  project                = var.project_id
  name                   = "run-${var.name}"
  location               = var.location
  resource_type_selector = "run.googleapis.com/Service"
}

resource "google_cloud_run_v2_service" "this" {
  project             = var.project_id
  name                = var.name
  location            = var.location
  labels              = var.labels
  deletion_protection = var.deletion_protection

  ingress = local.firebase ? "INGRESS_TRAFFIC_ALL" : "INGRESS_TRAFFIC_INTERNAL_ONLY"
  # Firebase Hosting rewrites call the service without IAM tokens; the app authenticates users.
  invoker_iam_disabled = local.firebase

  template {
    service_account                  = google_service_account.this.email
    encryption_key                   = google_kms_key_handle.this.kms_key
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    max_instance_request_concurrency = var.concurrency
    timeout                          = var.timeout

    scaling {
      min_instance_count = 0
      max_instance_count = var.max_instances
    }

    containers {
      image = var.image

      dynamic "env" {
        for_each = var.env
        content {
          name  = env.key
          value = env.value
        }
      }

      resources {
        limits   = { cpu = var.cpu, memory = var.memory }
        cpu_idle = true # CPU only while handling requests
      }
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "invoker" {
  for_each = local.firebase ? toset([]) : toset(var.invokers)

  project  = var.project_id
  location = var.location
  name     = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = each.value
}

resource "google_logging_project_exclusion" "requests" {
  count = var.exclude_request_logs ? 1 : 0

  project     = var.project_id
  name        = "run-${var.name}-requests"
  description = "Request logs of Cloud Run service ${var.name} (cost)"
  filter      = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${var.name}\" AND log_id(\"run.googleapis.com/requests\")"
}
