provider "kubernetes" {
  config_path = "kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "kube/config"
  }
}

locals {
  airflow_enabled  = false
  elastic_enabled  = true
  nifi_enabled     = true
  postgres_enabled = true
}
