resource "kubernetes_ingress_v1" "service-a" {
  metadata {
    name = "service-a"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/use-regex" = "true"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
    }
  }

  spec {
    ingress_class_name = "nginx"
    default_backend {
      service {
        name = "service-a"
        port {
          number = 5000
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = "service-a"
              port {
                number = 5000
              }
            }
          }
            path = "/service\\-a(/|$)(.*)"
            path_type = "ImplementationSpecific"
          
        }


      }
    }

   
  }
}