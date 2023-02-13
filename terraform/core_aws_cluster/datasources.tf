data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "debian" {

  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["136693071363"]
}
