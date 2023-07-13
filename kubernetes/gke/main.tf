locals {
  cluster_type = "simple-zonal"

  network    = "gke-network"
  subnetwork = "gke-subnet"

  ip_range_pods_name     = "gke-ip-range-pods"
  ip_range_services_name = "gke-ip-range-services"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gcp-network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 4.0.1"

  project_id   = var.project_id
  network_name = local.network

  subnets = [
    {
      subnet_name   = local.subnetwork
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    (local.subnetwork) = [
      {
        range_name    = local.ip_range_pods_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = local.ip_range_services_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

module "gke" {
  source = "../../terraform-modules/google-kubernetes-engine"

  project_id = var.project_id
  name       = "${local.cluster_type}-cluster"

  regional = false
  region   = var.region
  zones    = [var.zone]

  network           = module.gcp-network.network_name
  subnetwork        = module.gcp-network.subnets_names[0]
  ip_range_pods     = local.ip_range_pods_name
  ip_range_services = local.ip_range_services_name

  create_service_account = false
  service_account        = var.service_account

  node_pools = [
    {
      name         = "c3-standard-8-spot-node-pool"
      machine_type = "c3-standard-8"
      spot         = true
      disk_type    = "pd-balanced"
    },
    {
      name         = "c3-standard-22-spot-node-pool"
      machine_type = "c3-standard-22"
      spot         = true
      disk_type    = "pd-balanced"
    },
  ]
}
