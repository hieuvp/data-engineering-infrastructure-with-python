locals {

}

resource "kubernetes_namespace" "elastic" {
  metadata {
    name = "elastic"
  }
}

resource "helm_release" "elastic-operator" {
  count = local.elastic_enabled ? 1 : 0

  name      = "elastic-operator"
  chart     = "../helm-charts/elastic-operator"
  namespace = kubernetes_namespace.elastic.metadata.0.name

  set {
    name  = "managedNamespaces"
    value = "{${kubernetes_namespace.elastic.metadata.0.name}}"
  }

  values = [
    data.template_file.elastic-operator.rendered,
  ]
}

data "template_file" "elastic-operator" {
  template = file("elastic-operator.yaml")
  vars = {
  }
}

resource "helm_release" "elastic-stack" {
  count = local.elastic_enabled ? 1 : 0

  name      = "elastic-stack"
  chart     = "../helm-charts/elastic-stack"
  namespace = kubernetes_namespace.elastic.metadata.0.name

  values = [
    data.template_file.elastic-stack.rendered,
  ]

  depends_on = [
    helm_release.elastic-operator
  ]
}

data "template_file" "elastic-stack" {
  template = file("elastic-stack.yaml")
  vars = {
  }
}

output "elastic_enabled" {
  value = local.elastic_enabled
}
