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
  elastic_enabled  = true
  kafka_enabled    = false
  nifi_enabled     = true
  postgres_enabled = true
  spark_enabled    = false
}
