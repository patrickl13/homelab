resource "kubernetes_namespace" "plex" {
  metadata {
    name = "plex"
  }
}

resource "kubernetes_deployment" "plex" {
  metadata {
    name      = "plex"
    namespace = kubernetes_namespace.plex.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "plex"
      }
    }

    template {
      metadata {
        labels = {
          app = "plex"
        }
      }

      spec {
        container {
          name  = "plex"
          image = "plexinc/pms-docker:latest"

          port {
            container_port = 32400
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
          }

          volume_mount {
            name       = "movies"
            mount_path = "/movies"
          }
        }

        volume {
          name = "config"

          persistent_volume_claim {
            claim_name = "plex-config"
          }
        }

        volume {
          name = "data"

          persistent_volume_claim {
            claim_name = "plex-data"
          }
        }

        volume {
          name = "movies"
          host_path {
            path = "/home/patrick/plex-media/movies"
            type = "Directory"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "plex" {
  metadata {
    name      = "plex"
    namespace = kubernetes_namespace.plex.metadata[0].name
  }

  spec {
    selector = {
      app = "plex"
    }

    port {
      port        = 32400
      target_port = 32400
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}

resource "kubernetes_persistent_volume_claim" "plex_config" {
  metadata {
    name      = "plex-config"
    namespace = kubernetes_namespace.plex.metadata[0].name
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

resource "kubernetes_persistent_volume_claim" "plex_data" {
  metadata {
    name      = "plex-data"
    namespace = kubernetes_namespace.plex.metadata[0].name
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
