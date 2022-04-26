locals {
  instance_name_prefix       = terraform.workspace
  key_name                   = "${local.instance_name_prefix}_admin"
  instance_type              = "t3.micro"
  jump_host_instance_type    = "t3.micro"
  masters_instance_type      = "t3.micro"
  minions_instance_type      = "t3.micro"
  instance_image             = data.aws_ami.debian.id
  instance_enable_ipv6       = false
  instance_enable_dynamic_ip = false
  ssh_public_key_name        = "${local.instance_name_prefix}_key"
  ssh_public_key_file        = var.ssh_public_key_file
  raw_ssh_user               = "admin"
  private_subnet_cidr        = "192.168.42.0/24"
  private_subnet_gw          = "192.168.42.1"
}

resource "aws_key_pair" "admin" {
  key_name   = local.key_name
  public_key = file(local.ssh_public_key_file)
}

resource "aws_security_group" "controller" {
  name   = "${terraform.workspace}-controller"
  vpc_id = aws_vpc.sandbox-vpc.id

  ingress {
    description = "DNS Access"
    from_port   = "53"
    to_port     = "53"
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    description = "SSH Access"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "accept"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${terraform.workspace}-controller"
  }
}

resource "aws_security_group" "server" {
  name   = "${terraform.workspace}-servers"
  vpc_id = aws_vpc.sandbox-vpc.id

  ingress {
    description = "SSH Access"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "accept"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${terraform.workspace}-servers"
  }
}

resource "aws_instance" "controller" {

  ami                    = local.instance_image
  instance_type          = local.jump_host_instance_type
  vpc_security_group_ids = [aws_security_group.controller.id]
  key_name               = local.key_name
  subnet_id              = aws_subnet.sandbox-sb[var.aws_controller_az_index].id

  associate_public_ip_address = true

  tags = {
    Name = "${local.instance_name_prefix}-controller"
  }

  root_block_device {
    volume_type           = var.aws_controller_volume_type
    volume_size           = var.aws_controller_volume_size
    delete_on_termination = var.aws_controller_delete_on_termination
  }

}

resource "aws_instance" "masters" {

  for_each = var.masters_configuration

  ami                    = local.instance_image
  instance_type          = local.masters_instance_type
  availability_zone      = data.aws_availability_zones.available.names[each.value.aws_subnet_index] 
  vpc_security_group_ids = ["${aws_security_group.server.id}"]
  key_name               = local.key_name
  subnet_id              = aws_subnet.sandbox-sb[each.value.aws_subnet_index].id
  depends_on             = [aws_vpc_dhcp_options_association.sandbox-dns-resolver-association]
  associate_public_ip_address = true

  tags = {
    Name = each.value.name
  }

  root_block_device {
    volume_type           = each.value.aws_volume_type
    volume_size           = each.value.aws_volume_size
    delete_on_termination = each.value.aws_delete_on_termination
  }

}

resource "aws_instance" "minions" {

  count = 3

  ami                    = local.instance_image
  instance_type          = local.minions_instance_type
  availability_zone      = data.aws_availability_zones.available.names[var.aws_minions_az_index] 
  vpc_security_group_ids = ["${aws_security_group.server.id}"]
  subnet_id              = aws_subnet.sandbox-sb[var.aws_minions_az_index].id
  depends_on             = [aws_vpc_dhcp_options_association.sandbox-dns-resolver-association]
  key_name               = local.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${local.instance_name_prefix}-minion-0${count.index + 1}"
  }

  root_block_device {
    volume_type           = var.aws_minions_volume_type
    volume_size           = var.aws_minions_volume_size
    delete_on_termination = var.aws_minions_delete_on_termination
  }

}
