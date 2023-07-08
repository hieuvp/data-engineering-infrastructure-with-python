locals {
  nifi_name = "nifi"
  nifi_port = "30236"
}

resource "kubernetes_namespace" "nifi" {
  metadata {
    name = "nifi"
  }
}

resource "helm_release" "nifi" {
  name      = local.nifi_name
  chart     = "../helm-charts/nifi"
  namespace = kubernetes_namespace.nifi.metadata.0.name

  set {
    name  = "nameOverride"
    value = local.nifi_name
  }

  set {
    name  = "fullnameOverride"
    value = local.nifi_name
  }

  set {
    name  = "namespaceOverride"
    value = kubernetes_namespace.nifi.metadata.0.name
  }

  set {
    name  = "service.httpsPort"
    value = local.nifi_port
  }

  set {
    name  = "properties.httpsPort"
    value = local.nifi_port
  }

  # https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#security_properties
  set {
    name  = "properties.sensitiveKey"
    value = random_password.nifi_key.result
  }

  set {
    name  = "auth.singleUser.password"
    value = random_password.nifi_password.result
  }

  values = [
    data.template_file.nifi.rendered,
  ]
}

data "template_file" "nifi" {
  template = file("nifi.yaml")
  vars = {
  }
}

resource "random_password" "nifi_key" {
  length  = 16
  special = true
}

resource "random_password" "nifi_password" {
  length  = 16
  special = false
}

output "nifi_password" {
  sensitive = true
  value     = random_password.nifi_password.result
}

output "nifi_port" {
  value = local.nifi_port
}
