locals {
  spark_name = "spark"
}

resource "kubernetes_namespace" "spark" {
  metadata {
    name = "spark"
  }
}

resource "helm_release" "spark" {
  count = local.spark_enabled ? 1 : 0

  name      = local.spark_name
  chart     = "../helm-charts/spark"
  namespace = kubernetes_namespace.spark.metadata.0.name

  set {
    name  = "nameOverride"
    value = "${local.spark_name}-operator"
  }

  set {
    name  = "fullnameOverride"
    value = "${local.spark_name}-operator"
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.spark.metadata.0.name
  }

  values = [
    data.template_file.spark.rendered,
  ]
}

data "template_file" "spark" {
  template = file("spark.yaml")
  vars = {
  }
}
