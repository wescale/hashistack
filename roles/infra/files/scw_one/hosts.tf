resource "scaleway_account_ssh_key" "default" {
  name       = local.ssh_public_key_name
  public_key = trimspace(file(local.ssh_public_key_file))
}

module "sre" {
  source = "./node"

  node_name          = "${local.name_prefix}-sre"
  node_type          = local.instance_type_master
  node_image         = local.instance_image_all
  private_network_id = scaleway_vpc_private_network.internal.id
}

module "masters" {
  source = "./node"
  count  = var.instance_count_master

  node_name          = "${local.name_prefix}-master-${count.index + 1}"
  node_type          = local.instance_type_master
  node_image         = local.instance_image_all
  private_network_id = scaleway_vpc_private_network.internal.id
}

module "minions" {
  source = "./node"
  count  = var.instance_count_minion

  node_name          = "${local.name_prefix}-minion-${count.index + 1}"
  node_type          = local.instance_type_minion
  node_image         = local.instance_image_all
  private_network_id = scaleway_vpc_private_network.internal.id
}

