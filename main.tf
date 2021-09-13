provider "google" {}

terraform {
    backend "gcs" {}
}

resource "google_cloud_run_service" "default" {
  name     = "tenant-${tenant}-service"

  template {
    spec {
      containers {
        image = "gcr.io/google-samples/${container_name}:${container_tag}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}