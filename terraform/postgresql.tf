locals {
  postgresql_name = "postgresql"
}

resource "kubernetes_namespace" "postgres" {
  metadata {
    name = "postgres"
  }
}

resource "helm_release" "postgresql" {
  count = local.postgres_enabled ? 1 : 0

  name      = local.postgresql_name
  chart     = "../helm-charts/postgresql"
  namespace = kubernetes_namespace.postgres.metadata.0.name

  set {
    name  = "nameOverride"
    value = local.postgresql_name
  }

  set {
    name  = "fullnameOverride"
    value = local.postgresql_name
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.postgres.metadata.0.name
  }

  set {
    name  = "global.postgresql.auth.postgresPassword"
    value = random_password.postgresql_password.result
  }

  values = [
    data.template_file.postgresql.rendered,
  ]
}

data "template_file" "postgresql" {
  template = file("postgresql.yaml")
  vars = {
  }
}

resource "random_password" "postgresql_password" {
  length  = 16
  special = false
}

output "postgresql_password" {
  sensitive = true
  value     = random_password.postgresql_password.result
}
