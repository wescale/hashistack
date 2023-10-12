terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.21.0"
    }
  }
}

provider "vault" {
  ca_cert_file = var.vault_ca_cert_file
}
