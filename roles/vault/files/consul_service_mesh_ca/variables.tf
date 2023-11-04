variable "root_pki_path" {
  default = "pki/consul_root_ca"
}

variable "intermediate_pki_path" {
  default = "pki/consul_inter_ca"
}

variable "root_pki_issuing_server" {}
variable "root_pki_crl_distribution_point" {}
variable "intermediate_pki_issuing_server" {}
variable "intermediate_pki_crl_distribution_point" {}

