locals {
  elasticsearch_name = "elasticsearch"
}

resource "kubernetes_namespace" "elastic" {
  metadata {
    name = "elastic"
  }
}

resource "helm_release" "elasticsearch" {
  count = local.elastic_enabled ? 1 : 0

  name      = local.elasticsearch_name
  chart     = "../helm-charts/elasticsearch"
  namespace = kubernetes_namespace.elastic.metadata.0.name

  set {
    name  = "nameOverride"
    value = local.elasticsearch_name
  }

  set {
    name  = "fullnameOverride"
    value = local.elasticsearch_name
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.elastic.metadata.0.name
  }

  values = [
    data.template_file.elasticsearch.rendered,
  ]
}

data "template_file" "elasticsearch" {
  template = file("elasticsearch.yaml")
  vars = {
  }
}

data "kubernetes_secret" "elasticsearch_credentials" {
  metadata {
    name      = "elasticsearch-credentials"
    namespace = kubernetes_namespace.elastic.metadata.0.name
  }

  depends_on = [
    helm_release.elasticsearch
  ]
}

output "elastic_enabled" {
  value = local.elastic_enabled
}

output "elasticsearch_username" {
  sensitive = true
  value     = local.elastic_enabled ? data.kubernetes_secret.elasticsearch_credentials.data.username : null
}

output "elasticsearch_password" {
  sensitive = true
  value     = local.elastic_enabled ? data.kubernetes_secret.elasticsearch_credentials.data.password : null
}
