output "admin_lb_ip" {
  value = scaleway_lb_ip.admin.ip_address
}

output "apps_lb_ip" {
  value = scaleway_lb_ip.apps.ip_address
}
