variable "ssh_private_key" {
  type        = string
  description = "SSH private key for Docker provider"
}

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
  host = "ssh://patrick@173.206.63.235:2222" # SSH connection to your remote server
  # You can also specify a private key if needed, or it will use the default key
  #   private_key = var.ssh_private_key
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx_container" {
  name  = "nginx_container"
  image = docker_image.nginx.latest
  ports {
    internal = 80
    external = 8080
  }
}
