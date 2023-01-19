terraform {
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "2.16.2"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = "1.4.18"
    }
    dns = {
      source  = "hashicorp/dns"
      version = "3.2.3"
    }
  }
}

provider "dns" {
  update {
    server        = var.dns_server
    key_name      = local.dns_cname_zone
    key_algorithm = var.key_algorithm
    key_secret    = var.key_secret
  }
}

provider "consul" {
  # Configure by supplying env variables
  # => https://developer.hashicorp.com/consul/commands#environment-variables
  address    = var.consul_address
  datacenter = var.datacenter
  scheme     = "https"
}

provider "nomad" {
  address = var.nomad_address
  ca_file = var.ca_file
}
