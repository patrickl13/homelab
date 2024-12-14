terraform {
  cloud {

    organization = "patrick-leduc-aws"

    workspaces {
      name = "homelab-astartes"
    }
  }
}

provider "docker" {}
