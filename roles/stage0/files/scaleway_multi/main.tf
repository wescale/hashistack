locals {
  instance_name_prefix       = terraform.workspace
  jump_host_instance_type    = var.instance_type
  masters_instance_type      = var.instance_type
  minions_instance_type      = var.instance_type
  instance_image             = var.instance_image
  instance_enable_ipv6       = true
  instance_enable_dynamic_ip = true
  ssh_public_key_name        = "${local.instance_name_prefix}_key"
  ssh_public_key_file        = var.ssh_public_key_file
  raw_ssh_user               = "root"
  private_subnet_cidr        = "192.168.42.0/24"
  private_ip_sre             = "192.168.42.2"
}

resource "scaleway_account_ssh_key" "admin" {
  name       = local.ssh_public_key_name
  public_key = trimspace(file(local.ssh_public_key_file))
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

resource "scaleway_instance_server" "sre" {

  name  = "${local.instance_name_prefix}-sre"
  type  = local.jump_host_instance_type
  image = local.instance_image

  private_network {
    pn_id = scaleway_vpc_private_network.workspace.id
  }

  routed_ip_enabled = true

  security_group_id = scaleway_instance_security_group.server.id
}

resource "scaleway_vpc_public_gateway_dhcp_reservation" "entry" {
  gateway_network_id = scaleway_vpc_gateway_network.workspace.id
  mac_address        = scaleway_instance_server.sre.private_network.0.mac_address
  ip_address         = local.private_ip_sre
}

resource "scaleway_instance_server" "masters" {

  count = var.masters_count

  name              = "${local.instance_name_prefix}-master-0${count.index + 1}"
  type              = local.masters_instance_type
  image             = local.instance_image
  routed_ip_enabled = true

  security_group_id = scaleway_instance_security_group.server.id

  private_network {
    pn_id = scaleway_vpc_private_network.workspace.id
  }

  depends_on = [scaleway_vpc_gateway_network.workspace]
}

resource "scaleway_instance_server" "minions" {

  count = var.minions_count

  name              = "${local.instance_name_prefix}-minion-0${count.index + 1}"
  type              = local.minions_instance_type
  image             = local.instance_image
  routed_ip_enabled = true

  private_network {
    pn_id = scaleway_vpc_private_network.workspace.id
  }

  security_group_id = scaleway_instance_security_group.server.id

  depends_on = [scaleway_vpc_gateway_network.workspace]
}

resource "scaleway_vpc_private_network" "workspace" {
  name = terraform.workspace
}

resource "scaleway_vpc_public_gateway_dhcp" "workspace" {
  subnet             = local.private_subnet_cidr
  dns_local_name     = "hashistack"
  push_default_route = true
}

resource "scaleway_vpc_public_gateway_ip" "workspace" {}

resource "scaleway_vpc_public_gateway" "workspace" {
  name            = terraform.workspace
  type            = "VPC-GW-M"
  bastion_enabled = true

  ip_id = scaleway_vpc_public_gateway_ip.workspace.id
}

resource "scaleway_vpc_gateway_network" "workspace" {
  gateway_id         = scaleway_vpc_public_gateway.workspace.id
  private_network_id = scaleway_vpc_private_network.workspace.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.workspace.id
  enable_masquerade  = true
  enable_dhcp        = true
  cleanup_dhcp       = true
}

resource "scaleway_vpc_public_gateway_pat_rule" "http" {
  gateway_id   = scaleway_vpc_public_gateway.workspace.id
  private_ip   = local.private_ip_sre
  private_port = 80
  public_port  = 80
  protocol     = "tcp"
  depends_on   = [scaleway_vpc_gateway_network.workspace, scaleway_vpc_private_network.workspace]
}

resource "scaleway_vpc_public_gateway_pat_rule" "https" {
  gateway_id   = scaleway_vpc_public_gateway.workspace.id
  private_ip   = local.private_ip_sre
  private_port = 443
  public_port  = 443
  protocol     = "tcp"
  depends_on   = [scaleway_vpc_gateway_network.workspace, scaleway_vpc_private_network.workspace]
}

resource "scaleway_vpc_public_gateway_pat_rule" "dns" {
  gateway_id   = scaleway_vpc_public_gateway.workspace.id
  private_ip   = local.private_ip_sre
  private_port = 53
  public_port  = 53
  protocol     = "both"
  depends_on   = [scaleway_vpc_gateway_network.workspace, scaleway_vpc_private_network.workspace]
}



