terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "2.24.1"
    }
  }
}

provider "vault" {}
