provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "cluster-stirred-collie"
}


resource "kubernetes_deployment" "service-b-deployment" {
  metadata {
    name = "service-b-deployment"
    labels = {
      app = "service-b"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "service-b"
      }
    }

    template {
      metadata {
        labels = {
          app = "service-b"
        }
      }

      spec {
        container {
          name  = "service-b"
          image = "myswiftregistry.azurecr.io/service_b:v2"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}
