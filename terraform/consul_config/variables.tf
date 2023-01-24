variable "consul_address" {}
variable "datacenter" {}
variable "token" {}
variable "ca_file" {
  default = null
}
variable "minion_auto_encrypt_token_accessor_id" {}
