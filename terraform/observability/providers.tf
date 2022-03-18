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
    dns = {
      source = "hashicorp/dns"
      version = "3.2.1"
    }

  }
}

provider "dns" {
  update {
    server        = var.dns_server
    key_name      = var.key_name
    key_algorithm = var.key_algorithm
    key_secret    = var.key_secret
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
  ca_file    = var.ca_file
}
