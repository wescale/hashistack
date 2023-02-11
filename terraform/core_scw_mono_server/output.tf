output "raw_ssh_user" {
  value = local.raw_ssh_user
}

output "mono_ipv4" {
  value = scaleway_instance_server.mono.public_ip
}

output "mono_ipv6" {
  value = scaleway_instance_server.mono.ipv6_address
}

output "mono_private_ipv4" {
  value = scaleway_instance_server.mono.private_ip
}
