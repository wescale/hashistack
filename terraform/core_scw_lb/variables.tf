variable "masters_private_ipv4" {
  type = list
}

variable "minions_private_ipv4" {
  type = list
}

variable "admin_lb_domain" {}
variable "apps_lb_domain" {}
variable "private_network_id" {}

variable "cert_path" {}
variable "cert_key_path" {}
