terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
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
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_image" "home_assistant" {
  name = "homeassistant/home-assistant:stable"
}

resource "docker_container" "home_assistant" {
  name  = "home_assistant"
  image = docker_image.home_assistant.image_id

  ports {
    internal = 8123
    external = 8123
  }

  volumes {
    host_path      = "/data/home_assistant"
    container_path = "/config"
  }

  restart = "always"
  lifecycle {
    prevent_destroy = true
  }
}

# Prometheus Docker Image
resource "docker_image" "prometheus" {
  name = "prom/prometheus:v2.42.0"
}

# Prometheus Docker Container
resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.image_id

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    host_path      = "/data/prometheus"
    container_path = "/prometheus"
  }

  restart = "always"
  lifecycle {
    prevent_destroy = true
  }
}

# Grafana Docker Image
resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

# Grafana Docker Container
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
  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_image" "pihole" {
  name = "pihole/pihole:latest"
}

resource "docker_container" "pihole" {
  name  = "pihole"
  image = docker_image.pihole.image_id

  ports {
    internal = 53
    external = 53
  }

  ports {
    internal = 80
    external = 80
  }

  volumes {
    host_path      = "/data/pihole"
    container_path = "/etc/pihole"
  }

  restart = "always"
  lifecycle {
    prevent_destroy = true
  }
}
