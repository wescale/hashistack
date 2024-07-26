
output "default_ssh_user" {
  value = local.instance_default_ssh_user
}

output "private_network_domain" {
  value = scaleway_vpc_private_network.internal.name
}

output "edge_public_ipv4" {
  value = scaleway_vpc_public_gateway_ip.internal.address
}

output "edge_bastion_port" {
  value = scaleway_vpc_public_gateway.internal.bastion_port
}

output "private_network_cidr" {
  value = local.internal_cidr
}

output "masters_ipv4" {
  value = module.masters.*.node_ipv4
}

output "minions_ipv4" {
  value = module.minions.*.node_ipv4
}

output "sre_ipv4" {
  value = module.sre.node_ipv4
}

data "scaleway_ipam_ip" "edge" {
  ipam_ip_id = scaleway_ipam_ip.edge.id
}

output "edge_private_ipv4" {
  value = data.scaleway_ipam_ip.edge.address
}


