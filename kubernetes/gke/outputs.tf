output "project_id" {
  value = var.project_id
}

output "cluster_endpoint" {
  sensitive = true
  value     = module.gke.endpoint
}

output "cluster_name" {
  value = module.gke.name
}

output "cluster_zone" {
  value = var.zone
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}
