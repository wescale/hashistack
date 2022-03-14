output "ready_ssh_user" {
  value = local.raw_ssh_user
}

output "masters_ipv4" {
  value = [
    for machine in aws_instance.masters : machine.public_ip
  ]
}

output "minions_ipv4" {
  value = ["${aws_instance.minions.*.public_ip}"]
}