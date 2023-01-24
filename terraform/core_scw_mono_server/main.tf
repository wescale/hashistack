locals {
  instance_name_prefix       = terraform.workspace
  instance_type              = var.instance_type
  instance_image             = "debian_bullseye"
  instance_enable_ipv6       = true
  instance_enable_dynamic_ip = true
  ssh_public_key_name        = "${local.instance_name_prefix}_key"
  ssh_public_key_file        = var.ssh_public_key_file
  raw_ssh_user               = "root"
  private_subnet_cidr        = "192.168.42.0/24"
  private_subnet_gw          = "192.168.42.1"
}

resource "scaleway_account_ssh_key" "admin" {
  name       = local.ssh_public_key_name
  public_key = file(local.ssh_public_key_file)
}

resource "scaleway_instance_security_group" "server" {

  inbound_rule {
    action   = "accept"
    port     = 22
    protocol = "TCP"
    ip_range = "0.0.0.0/0"
  }

  outbound_rule {
    action = "accept"
  }
}

resource "scaleway_instance_server" "mononode" {

  name  = "${local.instance_name_prefix}-mononode"
  type  = local.instance_type
  image = local.instance_image

  enable_ipv6       = local.instance_enable_ipv6
  enable_dynamic_ip = local.instance_enable_dynamic_ip

  private_network {
    pn_id = scaleway_vpc_private_network.vpc.id
  }

  user_data = {
    cloud-init = templatefile("${path.module}/cloud-init.sre.yml", {})
  }

  security_group_id = scaleway_instance_security_group.server.id
}

resource "scaleway_vpc_private_network" "vpc" {
  name = terraform.workspace
}

resource "scaleway_vpc_public_gateway_dhcp" "public_gateway_dhcp" {
  subnet             = local.private_subnet_cidr
  push_default_route = false
  enable_dynamic     = true
}

resource "scaleway_vpc_public_gateway_ip" "public_ip" {}

resource "scaleway_vpc_public_gateway" "public_gateway" {
  name  = terraform.workspace
  type  = "VPC-GW-M"
  ip_id = scaleway_vpc_public_gateway_ip.public_ip.id
}

resource "scaleway_vpc_gateway_network" "vpc_gatewat" {
  gateway_id         = scaleway_vpc_public_gateway.public_gateway.id
  private_network_id = scaleway_vpc_private_network.vpc.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.public_gateway_dhcp.id
  enable_masquerade  = true
  enable_dhcp        = true
  cleanup_dhcp       = true
}
