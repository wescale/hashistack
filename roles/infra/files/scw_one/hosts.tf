resource "scaleway_account_ssh_key" "default" {
  name       = local.ssh_public_key_name
  public_key = trimspace(file(local.ssh_public_key_file))
}

resource "scaleway_instance_server" "sre" {
  name              = "${local.name_prefix}-sre"
  type              = local.instance_type_master
  image             = local.instance_image_all
  routed_ip_enabled = true

  private_network {
    pn_id = scaleway_vpc_private_network.internal.id
  }

  depends_on = [scaleway_vpc_gateway_network.internal]
}

resource "scaleway_instance_server" "master_1" {
  name              = "${local.name_prefix}-master-1"
  type              = local.instance_type_master
  image             = local.instance_image_all
  routed_ip_enabled = true

  private_network {
    pn_id = scaleway_vpc_private_network.internal.id
  }

  depends_on = [scaleway_instance_server.sre]
}

resource "scaleway_instance_server" "master_2" {
  name              = "${local.name_prefix}-master-2"
  type              = local.instance_type_master
  image             = local.instance_image_all
  routed_ip_enabled = true

  private_network {
    pn_id = scaleway_vpc_private_network.internal.id
  }

  depends_on = [scaleway_instance_server.master_1]
}

resource "scaleway_instance_server" "master_3" {
  name              = "${local.name_prefix}-master-3"
  type              = local.instance_type_master
  image             = local.instance_image_all
  routed_ip_enabled = true

  private_network {
    pn_id = scaleway_vpc_private_network.internal.id
  }

  depends_on = [scaleway_instance_server.master_2]
}

