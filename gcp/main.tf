provider "google" {
  credentials = file("../gcp_keys/my-first-gke-project-372214-64ee6b1be0c8.json")
  project = "my-first-gke-project-372214"
  region  = "europe-central2"
  zone    = "europe-central2-a"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = google_compute_network.vpc_network.self_link
    # network = "default"
    access_config {
    }
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction = "INGRESS"
  network = google_compute_network.vpc_network.id
  priority = 1000
  target_tags = ["ssh"]
  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}

# - https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started