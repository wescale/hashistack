terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "2.15.1"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "1.4.17"
    }
    dns = {
      source = "hashicorp/dns"
      version = "3.2.3"
    }

  }
}

provider "dns" {
  update {
    server        = var.dns_server
    key_name      = "${var.domain}."
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
  address = var.nomad_address
  ca_file    = var.ca_file
}
