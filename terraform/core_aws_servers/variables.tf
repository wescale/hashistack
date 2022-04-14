variable "masters_configuration" {
  type        = map(object({
    name              = string
    aws_az            = string
    aws_volume_type   = string
    aws_volume_size   = number
    aws_subnet_id     = number
    aws_delete_on_termination = string
    
  }))
}

variable "aws_controller_az" {
  type        = string
}

variable "aws_controller_volume_type" {
  type        = string
}

variable "aws_controller_volume_size" {
  type        = number
}

variable "aws_controller_delete_on_termination" {
  type        = string
}

variable "aws_minions_az" {
  type        = string
}

variable "aws_minions_volume_type" {
  type        = string
}

variable "aws_minions_volume_size" {
  type        = number
}

variable "aws_minions_delete_on_termination" {
  type        = string
}

variable "aws_controller_subnet_id" {
  type        = number
}

variable "aws_minions_subnet_id" {
  type        = number
}


variable "ssh_public_key_file" {

}
