terraform {

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  cloud {
    organization = "patrick-leduc-aws"

    workspaces {
      name = "homelab-astartes"
    }
  }

}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "homelab"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    <<EOF
    grafana:
      adminPassword: "supersecure"
    EOF
  ]
}


