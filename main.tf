provider "google" {}

terraform {
    backend "gcs" {}
}

resource "google_cloud_run_service" "default" {
  name     = "tenant-${var.tenant}-service"
  location = var.region
  project = var.project
  template {
    spec {
      containers {
        image = "gcr.io/google-samples/${var.container_name}:${var.container_tag}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

output "service_url" {
  value = google_cloud_run_service.default.url
}