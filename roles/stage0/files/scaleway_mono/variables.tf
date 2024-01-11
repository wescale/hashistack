variable "instance_type" {
  type    = string
  default = "DEV1-L"
}

variable "instance_image" {
  type    = string
  default = "debian_bookworm"
}

variable "ssh_public_key_file" {
  type = string
}
