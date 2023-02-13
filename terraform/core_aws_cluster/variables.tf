variable "masters_configuration" {
  type = map(object({
    name                      = string
    aws_az                    = string
    aws_volume_type           = string
    aws_volume_size           = number
    aws_subnet_index          = number
    aws_delete_on_termination = string
  }))
}


variable "aws_sre_az_index" {
  type    = number
  default = 1
}

variable "aws_sre_az" {
  type = string
}

variable "aws_sre_volume_type" {
  type = string
}

variable "aws_sre_volume_size" {
  type = number
}

variable "aws_sre_delete_on_termination" {
  type = string
}

variable "aws_minions_az_index" {
  type    = number
  default = 1
}

variable "aws_minions_volume_type" {
  type    = string
  default = "gp3"
}

variable "aws_minions_volume_size" {
  type    = number
  default = 8
}

variable "aws_minions_delete_on_termination" {
  type    = string
  default = "true"
}

variable "aws_sre_subnet_id" {
  type    = number
  default = 2
}

variable "aws_minions_subnet_id" {
  type    = number
  default = 0
}


variable "ssh_public_key_file" {

}
