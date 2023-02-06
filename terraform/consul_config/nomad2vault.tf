resource "consul_acl_policy" "vault" {
  name        = "vault"
  datacenters = [var.datacenter]
  rules       = file("${path.module}/policies/vault.hcl")
}

resource "consul_acl_token" "vault" {
  description = "vault register"
  policies    = [consul_acl_policy.vault.name]
  local       = true
}

data "consul_acl_token_secret_id" "vault" {
  accessor_id = consul_acl_token.vault.accessor_id
}

resource "consul_acl_policy" "nomad2vault" {
  name        = "nomad2vault"
  datacenters = [var.datacenter]
  rules       = file("${path.module}/policies/nomad2vault.hcl")
}

resource "consul_acl_token" "nomad2vault" {
  description = "nomad2vault register"
  policies    = [consul_acl_policy.nomad2vault.name]
  local       = true
}

data "consul_acl_token_secret_id" "nomad2vault" {
  accessor_id = consul_acl_token.nomad2vault.accessor_id
}

resource "consul_config_entry" "nomad2vault_protocol" {
  name = "nomad2vault"
  kind = "service-defaults"
  config_json = jsonencode({
    Protocol = "tcp"
  })
}

resource "consul_config_entry" "vault_protocol" {
  name = "vault"
  kind = "service-defaults"
  config_json = jsonencode({
    Protocol = "tcp"
  })
}


resource "consul_config_entry" "nomad2vault" {
  name = "nomad2vault"
  kind = "ingress-gateway"

  config_json = jsonencode({
    Listeners = [{
      Port     = 8200
      Protocol = "tcp"
      Services = [{ Name = "vault" }]
    }]
  })
  depends_on = [
    consul_config_entry.nomad2vault_protocol
  ]
}

resource "consul_config_entry" "nomad2vault_intentions" {
  name = "vault"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      { Action = "allow", Name = "nomad2vault" },
    ]
  })
}


