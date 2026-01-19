terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.6.0"
    }
  }
}

provider "vault" {}


