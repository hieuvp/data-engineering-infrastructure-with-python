locals {
  kibana_name = "kibana"
}

resource "helm_release" "kibana" {
  name      = local.kibana_name
  chart     = "../helm-charts/kibana"
  namespace = kubernetes_namespace.elastic.metadata.0.name

  set {
    name  = "nameOverride"
    value = local.kibana_name
  }

  set {
    name  = "fullnameOverride"
    value = local.kibana_name
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.elastic.metadata.0.name
  }

  values = [
    data.template_file.kibana.rendered,
  ]

  depends_on = [
    helm_release.elasticsearch
  ]
}

data "template_file" "kibana" {
  template = file("kibana.yaml")
  vars = {
  }
}
