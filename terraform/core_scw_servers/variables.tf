variable "instance_type" {
  type    = string
  default = "DEV1-M"
}

variable "ssh_public_key_file" {
  type = string
}

variable "masters_count" {
  type    = number
  default = 3
}

variable "minions_count" {
  type    = number
  default = 3
}
