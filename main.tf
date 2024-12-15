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
  ssh_opts = [
    "-i", "/tmp/ssh_private_key",
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null"
  ]
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx_container" {
  name  = "nginx_container"
  image = docker_image.nginx.image_id
}
