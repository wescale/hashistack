locals {
  nomad_cluster_allowed_policies = var.nomad_cluster_allowed_policies
}

data "template_file" "nomad_server_policy" {
  template = file("${path.module}/policy.nomad_server.tpl")

/* In case you want to pass variables to the template rendering
  vars = {
   
  }
*/
}

resource "vault_policy" "nomad_server" {
  name = "nomad_server"
  policy = data.template_file.nomad_server_policy.rendered
}

resource "vault_token" "nomad_server" {
  policies        = [vault_policy.nomad_server.name]
  renewable       = true
  ttl             = "1h"
  no_parent       = true
  renew_min_lease = 60 * 45
  renew_increment = 60 * 60
}

resource "vault_token_auth_backend_role" "nomad_cluster" {
  role_name              = "nomad_cluster"
  allowed_policies       = local.nomad_cluster_allowed_policies
  orphan                 = true
  token_period           = 60 * 60
  renewable              = true
  token_explicit_max_ttl = 0
}

