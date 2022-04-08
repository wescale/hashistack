variable "masters_private_ipv4" {
  type = list(string)
}

variable "minions_private_ipv4" {
  type = list(string)
}

variable "apps_lb_domain" {}
variable "private_network_id" {}

variable "cert_path" {}
variable "cert_key_path" {}
