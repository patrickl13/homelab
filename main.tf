terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  cloud {
    organization = "patrick-leduc-aws"

    workspaces {
      name = "homelab-astartes"
    }
  }

}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "portainer" {
  name = "portainer/portainer-ce:latest"
}

resource "docker_container" "portainer" {
  name  = "portainer"
  image = docker_image.portainer.image_id

  ports {
    internal = 9000
    external = 9000
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  volumes {
    host_path      = "/data/portainer"
    container_path = "/data"
  }

  restart = "always"
}

resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.image_id

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    host_path      = "/data/prometheus/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }

  restart = "always"

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  networks_advanced {
    name = "bridge"
  }

  # Ensure the host directory has the correct permissions and ensure that the prometheus.yml file is copied correctly
  provisioner "local-exec" {
    command = <<EOT
      sudo rm -rf /data/prometheus/prometheus.yml && \
      mkdir -p /data/prometheus && \
      sudo cp /home/patrick/prometheus/prometheus.yml /data/prometheus/prometheus.yml && \
      sudo chown -R 65534:65534 /data/prometheus && \
      sudo chmod -R 775 /data/prometheus
    EOT
  }
}

resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana.image_id

  ports {
    internal = 3000
    external = 3000
  }

  volumes {
    host_path      = "/data/grafana"
    container_path = "/var/lib/grafana"
  }

  restart = "always"
  # Ensure the host directory has the correct permissions
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p /data/grafana && \
      sudo chown -R 472:472 /data/grafana && \
      sudo chmod -R 775 /data/grafana
    EOT
  }
}

resource "docker_image" "loki" {
  name = "grafana/loki:latest"
}

resource "docker_container" "loki" {
  name  = "loki"
  image = docker_image.loki.image_id

  ports {
    internal = 3100
    external = 3100
  }

  volumes {
    host_path      = "/data/loki"
    container_path = "/loki"
  }

  restart = "always"
  # Ensure the host directory has the correct permissions
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p /data/loki && \
      sudo chown -R 10001:10001 /data/loki && \
      sudo chmod -R 775 /data/loki
    EOT
  }
}
