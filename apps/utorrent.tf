resource "kubernetes_namespace" "utorrent" {
  metadata {
    name = "utorrent"
  }
}

resource "kubernetes_deployment" "utorrent" {
  metadata {
    name      = "utorrent"
    namespace = kubernetes_namespace.utorrent.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "utorrent"
      }
    }

    template {
      metadata {
        labels = {
          app = "utorrent"
        }
      }

      spec {
        container {
          name  = "utorrent"
          image = "ekho/utorrent:latest"

          port {
            container_port = 8080
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
          }

          volume_mount {
            name       = "downloads"
            mount_path = "/downloads"
          }
        }

        volume {
          name = "config"

          persistent_volume_claim {
            claim_name = "utorrent-config"
          }
        }

        volume {
          name = "downloads"

          persistent_volume_claim {
            claim_name = "utorrent-downloads"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "utorrent" {
  metadata {
    name      = "utorrent"
    namespace = kubernetes_namespace.utorrent.metadata[0].name
  }

  spec {
    selector = {
      app = "utorrent"
    }

    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}

resource "kubernetes_persistent_volume_claim" "utorrent_config" {
  metadata {
    name      = "utorrent-config"
    namespace = kubernetes_namespace.utorrent.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "utorrent_downloads" {
  metadata {
    name      = "utorrent-downloads"
    namespace = kubernetes_namespace.utorrent.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}
