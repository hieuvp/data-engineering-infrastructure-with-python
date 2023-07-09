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

  values = [
    data.template_file.airflow.rendered,
  ]
}

data "template_file" "airflow" {
  template = file("airflow.yaml")
  vars = {
  }
}
