provider "aws" {
  region     = "eu-west-3"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "my-bucket"
    key    = "bucket-key"
    region = "eu-west-3"
  }
}
