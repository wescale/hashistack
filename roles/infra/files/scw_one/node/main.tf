terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.41.3"
    }
  }
  required_version = ">= 1.7"
}

# ----

variable "node_name" {
  type    = string
}

variable "node_type" {
  type    = string
}

variable "node_image" {
  type    = string
}

variable "private_network_id" {
  type    = string
}

# ----

resource "scaleway_instance_server" "node" {
  name              = var.node_name
  type              = var.node_type
  image             = var.node_image
  routed_ip_enabled = true
}

resource "scaleway_instance_private_nic" "node" {
  server_id          = scaleway_instance_server.node.id
  private_network_id = var.private_network_id
}

# ----

data "scaleway_ipam_ip" "node" {
  private_network_id = var.private_network_id
  type               = "ipv4"
  resource {
    type = "instance_private_nic"
    id   = scaleway_instance_private_nic.node.id
  }
}

output "node_ipv4" {
  value = data.scaleway_ipam_ip.node.address
}

