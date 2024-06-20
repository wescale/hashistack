variable "instance_image_all" {
  type    = string
  default = "debian_bookworm"
}

variable "instance_type_master" {
  type    = string
  default = "DEV1-S"
}

variable "ssh_public_key_file" {
  type = string
}

variable "parent_domain" {
  type = string
}

variable "instance_default_ssh_user" {
  type    = string
  default = "root"
}

