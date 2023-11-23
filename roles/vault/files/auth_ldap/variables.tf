variable "auth_backend_path" {
  type = string
}
variable "server_url" {
  type = string
}
variable "user_dn" {
  type = string
}
variable "user_attr" {
  type = string
}
variable "bind_dn" {
  type = string
}
variable "bind_pass" {
  type = string
}
variable "user_principal_domain" {
  type = string
}
variable "discover_dn" {
  type    = bool
  default = false
}

variable "starttls" {
  type    = bool
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

