variable "kv_v2_mount_point" {
  type = string
}

variable "policy_management_token_ttl" {
  type    = string
  default = "24h"
}

variable "policy_management_token_renewable" {
  type    = bool
  default = true
}

variable "policy_management_token_renew_min_lease" {
  type    = number
  default = 43200
}

variable "policy_management_token_renew_increment" {
  type    = number
  default = 86400
}

