variable "domain_name" {
  type = string
}

variable "subdomain_name" {
  type = string
}

variable "subdomain_authority_ipv4" {
  type = string
}

variable "subdomain_authority_ipv6" {
  type    = string
  default = null
}

variable "ttl" {
  type    = number
  default = 600
}

