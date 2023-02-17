locals {
  minion2vault_name = "minion2vault"
}

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




resource "consul_acl_policy" "minion2vault" {
  name        = local.minion2vault_name
  datacenters = [var.datacenter]
  rules       = file("${path.module}/policies/minion2vault.hcl")
}

resource "consul_acl_token" "minion2vault" {
  description = "minion2vault register"
  policies    = [consul_acl_policy.minion2vault.name]
  local       = true
}

data "consul_acl_token_secret_id" "minion2vault" {
  accessor_id = consul_acl_token.minion2vault.accessor_id
}

resource "consul_config_entry" "minion2vault_defaults" {
  name = local.minion2vault_name
  kind = "service-defaults"
  config_json = jsonencode({
    Protocol = "tcp"
  })
}

resource "consul_config_entry" "vault" {
  name = "vault"
  kind = "service-defaults"
  config_json = jsonencode({
    Protocol = "tcp"
  })
}

resource "consul_config_entry" "minion2vault" {
  name = local.minion2vault_name
  kind = "ingress-gateway"

  config_json = jsonencode({
    Listeners = [{
      Port     = 8200
      Protocol = "tcp"
      Services = [{ Name = "vault" }]
    }]
  })
  depends_on = [
    consul_config_entry.minion2vault_defaults
  ]
}

resource "consul_config_entry" "vault_sidecar_proxy" {
  name = "vault-sidecar-proxy"
  kind = "service-defaults"

  config_json = jsonencode({
    protocol = "tcp"
    proxy = {
      destination_service_name = "vault"
      local_service_port       = 8200
      local_request_timeout_ms = 0
      local_idle_timeout_ms = 0
    }
  })
  depends_on = [
    consul_config_entry.minion2vault_defaults
  ]
}


resource "consul_config_entry" "vault_intentions" {
  name = "vault"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      { Action = "allow", Name = local.minion2vault_name },
    ]
  })
}


