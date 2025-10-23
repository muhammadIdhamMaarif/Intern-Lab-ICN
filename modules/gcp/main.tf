provider "google" {
  project = var.project
  region  = var.region
  default_labels = {
    global_key  = "one"
    default_key = "two"
  }
}

data "google_compute_zones" "this" {
  region = var.region
  status = "UP"
}

locals {
  available_zones = length(var.zone) > 0 ? var.zone : data.google_compute_zones.this.names
  primary_zone    = local.available_zones[0]
  ha_zones        = slice(local.available_zones, 0, min(3, length(local.available_zones)))
}

resource "google_compute_instance" "inu_instance" {
  name         = "inu"
  machine_type = var.gce_machine_type
  zone         = local.primary_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {

    }
  }
}

resource "google_compute_network" "tori_network" {
  name                    = "tori"
  auto_create_subnetworks = "true"
}

