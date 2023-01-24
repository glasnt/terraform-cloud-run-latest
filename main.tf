# Google Cloud Services to enable

locals {
  services = [
    "run.googleapis.com",
    "iam.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

resource "google_project_service" "enabled" {
  for_each                   = toset(local.services)
  project                    = var.project
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = false
}

provider "google" {
  project = var.project
  region  = var.region
}

data "google_project" "project" {
  project_id = var.project
}

resource "google_cloud_run_service" "server" {
  name                       = var.service_name
  location                   = var.region
  autogenerate_revision_name = true
  template {
    spec {
      containers {
        image = data.google_container_registry_image.server.image_url
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "100"
        "run.googleapis.com/client-name"   = "terraform"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "server_noauth" {
  location    = google_cloud_run_service.server.location
  project     = google_cloud_run_service.server.project
  service     = google_cloud_run_service.server.name
  policy_data = var.public ? data.google_iam_policy.noauth.policy_data : "{}"
}

### Container

# Use the docker registry providers to get accurate latest image information
# Allows Terraform to always update to the container image associated as "latest" without
# locking to the literal string "latest". 
# https://github.com/hashicorp/terraform-provider-google/issues/6706#issuecomment-657039775

# Registry
data "google_client_config" "default" {}

locals {
  # these match the values in /cloudbuild.yaml
  gcr_hostname   = "gcr.io"
  image_registry = "${local.gcr_hostname}/${var.project}"
}


# Authenticate to our container registry
provider "docker" {
  registry_auth {
    address  = local.gcr_hostname
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}

# Establish image name
data "docker_registry_image" "server" {
  name = "${local.image_registry}/${var.image_name}"
}

# Get exact image information
data "google_container_registry_image" "server" {
  name    = var.image_name
  project = var.project
  digest  = data.docker_registry_image.server.sha256_digest
}
