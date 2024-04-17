resource "kubernetes_service" "rabbitmq" {
  metadata {
    name      = "service-a"
    namespace = "default"
    # annotations = var.service_annotations
  }

  spec {
    type = "ClusterIP"
    selector = {
      app = "service-a"
    }

    port {
      name        = "http"
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

  }
}