variable "instance_image_all" {
  type    = string
  default = "debian_bookworm"
}

variable "instance_type_master" {
  type    = string
  default = "DEV1-S"
}

variable "instance_count_master" {
  type    = number
  default = 3
}

variable "instance_type_minion" {
  type    = string
  default = "DEV1-S"
}

variable "instance_count_minion" {
  type    = number
  default = 0
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

