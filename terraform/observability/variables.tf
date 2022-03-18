variable "consul_address" {}
variable "nomad_address" {}
variable "datacenter" {}
variable "token" {}
variable "scheme" {
  default = "https"
}

variable "ca_file" {}
variable "domain" {}
variable "subdomain" {}

variable "dns_server" {}
