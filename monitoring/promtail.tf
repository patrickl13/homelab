resource "helm_release" "promtail" {
  name             = "promtail"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "promtail"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    # Custom values for Promtail configuration
    <<EOF
    promtail:
      config:
        clients:
          - url: "http://loki-gateway.monitoring.svc.cluster.local/loki/api/v1/push"
    EOF
  ]
}
