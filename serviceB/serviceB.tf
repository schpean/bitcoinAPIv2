resource "kubernetes_service" "rabbitmq" {
  metadata {
    name      = "service-b"
    namespace = "default"
    # annotations = var.service_annotations
  }

  spec {
    type = "ClusterIP"
    selector = {
      app = "service-b"
    }

    port {
      name        = "http"
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

  }
}