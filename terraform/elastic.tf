locals {
  elastic_name = "elastic"
}

resource "kubernetes_namespace" "elastic" {
  metadata {
    name = "elastic"
  }
}

resource "helm_release" "elastic" {
  count = local.elastic_enabled ? 1 : 0

  name      = local.elastic_name
  chart     = "../helm-charts/elastic"
  namespace = kubernetes_namespace.elastic.metadata.0.name

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.elastic.metadata.0.name
  }

  set {
    name  = "managedNamespaces"
    value = "{${kubernetes_namespace.elastic.metadata.0.name}}"
  }

  values = [
    data.template_file.elastic.rendered,
  ]
}

data "template_file" "elastic" {
  template = file("elastic.yaml")
  vars = {
  }
}
