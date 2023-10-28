module "reset_env" {
  source = "../m0-reset-env"

  project_id      = var.project_id
  enable_apis     = var.enable_apis
  remove_previous = var.remove_previous
}

data "google_compute_zones" "main" {
  depends_on = [module.reset_env]
}

resource "google_compute_network" "main" {
  depends_on = [module.reset_env]

  name                    = var.default_vpc_nm
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "${var.default_vpc_nm}-allow-icmp"
  network = google_compute_network.main.self_link

  description   = "Allow ICMP from anywhere"
  direction     = "INGRESS"
  priority      = 65534
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.default_vpc_nm}-allow-internal"
  network = google_compute_network.main.self_link

  description   = "Allow internal traffic on the network '${var.default_vpc_nm}'"
  direction     = "INGRESS"
  priority      = 65534
  source_ranges = ["10.128.0.0/9"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "allow_rdp" {
  count = length(var.rdp_ssh_source_ranges) > 0 ? 1 : 0

  name    = "${var.default_vpc_nm}-allow-rdp"
  network = google_compute_network.main.self_link

  description   = "Allow RDP from restricted source addresses"
  direction     = "INGRESS"
  priority      = 65534
  source_ranges = var.rdp_ssh_source_ranges[*].ip_range

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}

resource "google_compute_firewall" "allow_ssh" {
  count = length(var.rdp_ssh_source_ranges) > 0 ? 1 : 0

  name    = "${var.default_vpc_nm}-allow-ssh"
  network = google_compute_network.main.self_link

  description   = "Allow SSH from restricted source addresses"
  direction     = "INGRESS"
  priority      = 65534
  source_ranges = var.rdp_ssh_source_ranges[*].ip_range

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
