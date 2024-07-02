locals {
  name_prefix               = terraform.workspace
  instance_type_master      = var.instance_type_master
  instance_image_all        = var.instance_image_all
  ssh_public_key_name       = "${local.name_prefix}-service"
  ssh_public_key_file       = var.ssh_public_key_file
  instance_default_ssh_user = var.instance_default_ssh_user
  internal_cidr             = "10.42.42.0/24"

  edge_ip               = "10.42.42.2"
  sre_ip                = "10.42.42.2"
  master_1_ip           = "10.42.42.3"
  master_2_ip           = "10.42.42.4"
  master_3_ip           = "10.42.42.5"
  public_gw_type        = "VPC-GW-S"
  private_network_name  = "${local.name_prefix}.hs"
  parent_domain         = var.parent_domain
  delegated_subdomain   = terraform.workspace
  delegation_ns_name    = "ns.${local.delegated_subdomain}"
  delegation_record_ttl = 600
}

resource "scaleway_vpc_public_gateway_ip" "internal" {}

resource "scaleway_vpc_public_gateway" "internal" {
  name            = terraform.workspace
  type            = local.public_gw_type
  ip_id           = scaleway_vpc_public_gateway_ip.internal.id
  bastion_enabled = true
}

resource "scaleway_vpc" "internal" {
  name = local.name_prefix
  lifecycle {
    ignore_changes = all
  }
}

resource "scaleway_ipam_ip" "edge" {
  address = local.edge_ip
  source {
    private_network_id = scaleway_vpc_private_network.internal.id
  }
}

resource "scaleway_vpc_private_network" "internal" {
  name   = local.private_network_name
  vpc_id = scaleway_vpc.internal.id

  ipv4_subnet {
    subnet = local.internal_cidr
  }
}

resource "scaleway_vpc_gateway_network" "internal" {
  gateway_id         = scaleway_vpc_public_gateway.internal.id
  private_network_id = scaleway_vpc_private_network.internal.id
  enable_masquerade  = true
  ipam_config {
    push_default_route = true
    ipam_ip_id         = scaleway_ipam_ip.edge.id
  }
}

