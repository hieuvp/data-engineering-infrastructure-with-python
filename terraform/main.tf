provider "kubernetes" {
  config_path = "kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "kube/config"
  }
}

locals {
  airflow_enabled  = true
  elastic_enabled  = false
  nifi_enabled     = false
  postgres_enabled = true
}
