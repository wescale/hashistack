variable "root_pki_path" {
  default = "pki/consul_root_ca"
}

variable "intermediate_pki_path" {
  default = "pki/consul_inter_ca"
}

variable "vault_ca_cert_file" {
  type = string
  default = null
}

variable "vault_address" {}

variable "nomad_cluster_allowed_policies" {
  type = list(string)
  default = []
}
