output "raw_ssh_user" {
  value = local.raw_ssh_user
}

output "mononode_ipv4" {
  value = scaleway_instance_server.mononode.public_ip
}

output "mononode_ipv6" {
  value = scaleway_instance_server.mononode.ipv6_address
}
