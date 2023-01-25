variable "project" {
  type        = string
  description = "Google Cloud Project ID"
}

variable "public" {
  type        = bool
  description = "Allow unauthenticated invocations"
  default     = true
}

variable "region" {
  type        = string
  description = "Google Cloud Region"
  default     = "us-central1"
}

variable "service_name" {
  type        = string
  description = "Cloud Run service name"
}


variable "image_name" {
  type        = string
  description = "Container Registry image name, in your current project (gcr.io/PROJECT/IMAGE_NAME)"
}
