terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.12.0"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}
