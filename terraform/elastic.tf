resource "kubernetes_namespace" "elastic" {
  metadata {
    name = "elastic"
  }
}
