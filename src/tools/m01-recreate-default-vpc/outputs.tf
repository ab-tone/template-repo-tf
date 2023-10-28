output "zones" {
  description = "Available zones in region"
  value       = data.google_compute_zones.main.names
}
