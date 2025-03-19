resource "kubernetes_namespace" "pihole" {
  metadata {
    name = "pihole"
  }
}

resource "kubernetes_deployment" "pihole" {
  metadata {
    name      = "pihole"
    namespace = kubernetes_namespace.pihole.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pihole"
      }
    }

    template {
      metadata {
        labels = {
          app = "pihole"
        }
      }

      spec {
        container {
          name  = "pihole"
          image = "pihole/pihole:latest"

          port {
            container_port = 80
          }

          port {
            container_port = 53
          }

          env {
            name  = "TZ"
            value = "America/Los_Angeles"
          }

          env {
            name  = "WEBPASSWORD"
            value = "changeme"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pihole" {
  metadata {
    name      = "pihole"
    namespace = kubernetes_namespace.pihole.metadata[0].name
  }

  spec {
    selector = {
      app = "pihole"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    port {
      name        = "dns"
      port        = 53
      target_port = 53
      protocol    = "UDP"
    }

    type = "NodePort"
  }
}
