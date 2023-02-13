masters_configuration = {
  "master-1" = {
    name                      = "master-1"
    aws_az                    = "eu-west-2a"
    aws_volume_type           = "gp3"
    aws_volume_size           = 8
    aws_subnet_index          = 0
    aws_delete_on_termination = "true"
  },
  "master-2" = {
    name                      = "master-2"
    aws_az                    = "eu-west-2b"
    aws_volume_type           = "gp3"
    aws_volume_size           = 8
    aws_subnet_index          = "1"
    aws_delete_on_termination = "true"
  },
  "master-3" = {
    name                      = "master-3"
    aws_az                    = "eu-west-2c"
    aws_volume_type           = "gp3"
    aws_volume_size           = 8
    aws_subnet_index          = "2"
    aws_delete_on_termination = "true"
  }
}

aws_controller_volume_type           = "gp3"
aws_controller_volume_size           = 8
aws_controller_az                    = "eu-west-2a"
aws_controller_delete_on_termination = "true"
aws_controller_subnet_id             = 0
