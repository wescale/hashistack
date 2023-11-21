variable "real_name" {
  type = string
}

variable "kv_v2_mount_point" {
  type = string
}

variable "admin_token_ttl" {
  type    = string
  default = "24h"
}

variable "admin_token_renewable" {
  type    = bool
  default = true
}

variable "admin_token_renew_min_lease" {
  type    = number
  default = 43200
}

variable "admin_token_renew_increment" {
  type    = number
  default = 86400
}

variable "user_token_ttl" {
  type    = string
  default = "24h"
}

variable "user_token_renewable" {
  type    = bool
  default = true
}

variable "user_token_renew_min_lease" {
  type    = number
  default = 43200
}

variable "user_token_renew_increment" {
  type    = number
  default = 86400
}

