terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.22.0"
    }
  }
}

# env vars must be set
# VAULT_TOKEN: vault token with rights create token / policies
# VAULT_TOKEN_NAME: vault token parent name for audit logs
# VAULT_ADDR: vault url

provider "vault" {
}