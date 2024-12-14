terraform {
  cloud {
    organization = "patrick-leduc-aws"

    workspaces {
      name = "homelab-astartes"
    }
  }
}

provider "docker" {
  host        = "ssh://pi@192.168.86.60"
  private_key = file("/path/to/your/private/key")
}

resource "docker_container" "nginx" {
  image = "nginx:latest"
  name  = "nginx-container"
  ports {
    internal = 80
    external = 8080
  }
}
