locals {
  kafka_name = "kafka"
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

resource "helm_release" "kafka" {
  count = local.kafka_enabled ? 1 : 0

  name      = local.kafka_name
  chart     = "../helm-charts/kafka"
  namespace = kubernetes_namespace.kafka.metadata.0.name


  values = [
    data.template_file.kafka.rendered,
  ]
}

data "template_file" "kafka" {
  template = file("kafka.yaml")
  vars = {
  }
}
