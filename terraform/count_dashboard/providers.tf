terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "2.14.0"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "1.4.16"
    }

  }
}

provider "consul" {
  address    = var.consul_address
  datacenter = var.datacenter
  token      = var.token
  ca_file    = var.ca_file
  scheme     = "https"
}

provider "nomad" {
  address = "${var.scheme}://${var.nomad_address}"
  ca_file = var.ca_file
}
