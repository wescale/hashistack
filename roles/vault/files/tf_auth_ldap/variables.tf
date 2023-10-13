variable "auth_backend_path" {
  type    = string
}
variable "server_url" {
  type    = string
}
variable "user_dn" {
  type    = string
}
variable "user_attr" {
  type    = string
}
variable "user_principal_domain" {
  type    = string
}
variable "discover_dn" {
  type    = boolean
  default = false
}
variable "group_dn" {
  type    = string
  default = null
}
variable "group_filter" {
  type    = string
  default = null
}

