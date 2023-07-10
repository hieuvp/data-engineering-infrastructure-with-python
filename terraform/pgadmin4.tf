locals {
  pgadmin4_name  = "pgadmin4"
  pgadmin4_email = "admin@localhost.com"
}

resource "helm_release" "pgadmin4" {
  count = local.postgres_enabled ? 1 : 0

  name      = local.pgadmin4_name
  chart     = "../helm-charts/pgadmin4"
  namespace = kubernetes_namespace.postgres.metadata.0.name

  set {
    name  = "nameOverride"
    value = local.pgadmin4_name
  }

  set {
    name  = "fullnameOverride"
    value = local.pgadmin4_name
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.postgres.metadata.0.name
  }

  set {
    name  = "env.email"
    value = local.pgadmin4_email
  }

  set {
    name  = "env.password"
    value = random_password.pgadmin_password.result
  }


  values = [
    data.template_file.pgadmin4.rendered,
  ]
}

data "template_file" "pgadmin4" {
  template = file("pgadmin4.yaml")
  vars = {
  }
}


output "pgadmin_email" {
  sensitive = true
  value     = local.pgadmin4_email
}

resource "random_password" "pgadmin_password" {
  length  = 16
  special = false
}

output "pgadmin_password" {
  sensitive = true
  value     = random_password.pgadmin_password.result
}
