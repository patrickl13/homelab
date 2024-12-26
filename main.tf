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
}

resource "docker_image" "pihole" {
  name = "pihole/pihole:latest"
}

resource "docker_container" "pihole" {
  name  = "pihole"
  image = docker_image.pihole.image_id

  ports {
    internal = 53
    external = 5353
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

resource "docker_image" "plex" {
  name = "linuxserver/plex:latest"
}

resource "docker_container" "plex" {
  name  = "plex"
  image = docker_image.plex.image_id

  ports {
    internal = 32400
    external = 32400
  }

  ports {
    internal = 32469
    external = 32469
    protocol = "udp"
  }

  ports {
    internal = 32410
    external = 32410
    protocol = "udp"
  }

  ports {
    internal = 32412
    external = 32412
    protocol = "udp"
  }

  ports {
    internal = 32413
    external = 32413
    protocol = "udp"
  }

  ports {
    internal = 32414
    external = 32414
    protocol = "udp"
  }

  ports {
    internal = 1900
    external = 1900
    protocol = "udp"
  }

  volumes {
    host_path      = "/data/plex/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/data/plex/transcode"
    container_path = "/transcode"
  }

  volumes {
    host_path      = "/mnt/external_drive/movies"
    container_path = "/movies"
  }

  environment = {
    PUID = "1000"
    PGID = "1003"
    TZ   = "America/New_York" # Replace with your timezone
  }

  restart = "always"

  # Ensure the host directories have the correct permissions
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p /data/plex/config /data/plex/transcode /mnt/external_drive/movies && \
      sudo chown -R 1000:1000 /data/plex /mnt/external_drive/movies && \
      sudo chmod -R 775 /data/plex /mnt/external_drive/movies
    EOT
  }
}
