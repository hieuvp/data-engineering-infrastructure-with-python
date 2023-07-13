locals {
  airflow_name = "airflow"
}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = "airflow"
  }
}

resource "helm_release" "airflow" {
  count = local.airflow_enabled ? 1 : 0

  name      = local.airflow_name
  chart     = "../helm-charts/airflow"
  namespace = kubernetes_namespace.airflow.metadata.0.name

  set {
    name  = "nameOverride"
    value = local.airflow_name
  }

  set {
    name  = "fullnameOverride"
    value = local.airflow_name
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.airflow.metadata.0.name
  }

  set {
    name  = "webserver.defaultUser.password"
    value = random_password.airflow_password.result
  }

  values = [
    data.template_file.airflow.rendered,
  ]
}

data "template_file" "airflow" {
  template = file("airflow.yaml")
  vars = {
  }
}

resource "random_password" "airflow_password" {
  length  = 16
  special = false
}

output "airflow_password" {
  sensitive = true
  value     = random_password.airflow_password.result
}
