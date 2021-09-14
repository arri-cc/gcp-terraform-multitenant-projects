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

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

output "url" {
  value = google_cloud_run_service.default.status[0].url
}