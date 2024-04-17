provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "cluster-stirred-collie"
}


resource "kubernetes_deployment" "service-a-deployment" {
  metadata {
    name = "service-a-deployment"
    labels = {
      app = "service-a"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "service-a"
      }
    }

    template {
      metadata {
        labels = {
          app = "service-a"
        }
      }

      spec {
        container {
          name  = "service-a"
          image = "myswiftregistry.azurecr.io/service_a:v2"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}
