variable "project_id" {
  description = "Project that owns the service."
  type        = string
}

variable "name" {
  description = "Service name; also used for its dedicated service account (6–30 chars)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.name))
    error_message = "name must be 6–30 lowercase letters, digits or hyphens (it doubles as the service account ID)."
  }
}

variable "service_account_email" {
  description = "Existing service account to run as (e.g. a runtime account from the glitch-lz project factory, which can hold IAM roles a deployer can't grant). Null creates a dedicated role-less one."
  type        = string
  default     = null
}

variable "location" {
  description = "Region (org policy: europe-west3, or another EU region with the location=eu tag)."
  type        = string
  default     = "europe-west3"
}

variable "image" {
  description = "Container image, ideally pinned by digest (REGION-docker.pkg.dev/PROJECT/REPO/IMAGE@sha256:...). Must come from a CMEK Artifact Registry repo."
  type        = string
}

variable "max_instances" {
  description = "Hard cap on instances — required, so a traffic flood degrades the service instead of growing the bill."
  type        = number

  validation {
    condition     = var.max_instances >= 1 && var.max_instances <= 10
    error_message = "max_instances must be between 1 and 10."
  }
}

variable "access" {
  description = <<-EOT
    Who can reach the service:
    - "internal": ingress internal only, IAM invoker check on (service-to-service).
    - "firebase": ingress all + no IAM invoker check, for services behind a Firebase Hosting
      rewrite (Hosting doesn't send IAM tokens). The app MUST authenticate every request itself,
      and the project needs the ingress=public tag.
  EOT
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["internal", "firebase"], var.access)
    error_message = "access must be \"internal\" or \"firebase\"."
  }
}

variable "invokers" {
  description = "Principals allowed to invoke the service when access = \"internal\"."
  type        = list(string)
  default     = []
}

variable "env" {
  description = "Plain environment variables (no secrets — use Secret Manager for those)."
  type        = map(string)
  default     = {}
}

variable "cpu" {
  description = "CPU limit per instance."
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory limit per instance."
  type        = string
  default     = "512Mi"
}

variable "concurrency" {
  description = "Max concurrent requests per instance."
  type        = number
  default     = 80
}

variable "timeout" {
  description = "Request timeout."
  type        = string
  default     = "30s"
}

variable "exclude_request_logs" {
  description = "Drop this service's request logs from _Default (Cloud Logging ingestion is billed; errors from the app itself are kept)."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Block terraform destroy of the service — keep true in prod."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels (app / env / owner / managed_by)."
  type        = map(string)
  default     = {}
}
