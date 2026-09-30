variable "project_id" {
  description = "Project that owns the repository."
  type        = string
}

variable "repository_id" {
  description = "Repository name, e.g. \"wiki\"."
  type        = string
}

variable "location" {
  description = "Region of the repository (org policy: europe-west3, or another EU region with the location=eu tag)."
  type        = string
  default     = "europe-west3"
}

variable "description" {
  description = "Human-readable description."
  type        = string
  default     = ""
}

variable "keep_recent" {
  description = "Tagged versions of each image to keep; older ones are deleted by the cleanup policy."
  type        = number
  default     = 5

  validation {
    condition     = var.keep_recent >= 1 && var.keep_recent <= 50
    error_message = "keep_recent must be between 1 and 50."
  }
}

variable "readers" {
  description = "Principals (IAM member strings) that may pull images, e.g. a Cloud Run service account in another project. Same-project Cloud Run needs nothing here."
  type        = list(string)
  default     = []
}

variable "writers" {
  description = "Principals (IAM member strings) that may push images, e.g. the CI deployer service account."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels (app / env / owner / managed_by)."
  type        = map(string)
  default     = {}
}
