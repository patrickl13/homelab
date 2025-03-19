# resource "helm_release" "pihole" {
#   name             = "pihole"
#   repository       = "https://savepointsam.github.io/charts"
#   chart            = "pihole"
#   namespace        = "network"
#   create_namespace = true
#   wait             = false

#   set {
#     name  = "service.type"
#     value = "NodePort"
#   }

#   set {
#     name  = "persistence.enabled"
#     value = "true"
#   }

#   set {
#     name  = "persistence.size"
#     value = "10Gi"
#   }

#   set {
#     name  = "service.nodePort"
#     value = "32080"
#   }
# }
