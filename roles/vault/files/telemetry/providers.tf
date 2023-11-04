terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.21.0"
    }
  }
}

provider "vault" {}
