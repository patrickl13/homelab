resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    # Custom values for Loki configuration
    <<EOF
    loki:
      auth_enabled: false
      commonConfig:
        replication_factor: 1
      schemaConfig:
        configs:
          - from: "2024-04-01"
            store: tsdb
            object_store: s3
            schema: v13
            index:
              prefix: loki_index_
              period: 24h
      pattern_ingester:
          enabled: true
      limits_config:
        allow_structured_metadata: true
        volume_enabled: true
      ruler:
        enable_api: true

    minio:
      enabled: true
          
    deploymentMode: SingleBinary

    singleBinary:
      replicas: 1

    # Zero out replica counts of other deployment modes
    backend:
      replicas: 0
    read:
      replicas: 0
    write:
      replicas: 0

    ingester:
      replicas: 0
    querier:
      replicas: 0
    queryFrontend:
      replicas: 0
    queryScheduler:
      replicas: 0
    distributor:
      replicas: 0
    compactor:
      replicas: 0
    indexGateway:
      replicas: 0
    bloomCompactor:
      replicas: 0
    bloomGateway:
      replicas: 0
    EOF
  ]

}
