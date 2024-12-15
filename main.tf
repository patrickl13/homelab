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
