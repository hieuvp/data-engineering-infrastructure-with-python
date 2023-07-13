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
