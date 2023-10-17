resource "vault_policy" "dr_secondary_promotion" {
  name   = "dr_secondary_promotion"
  policy = templatefile("${path.module}/policies/dr_secondary_promotion.tpl", {})
}


resource "vault_token_auth_backend_role" "failover_handler" {
  role_name        = "failover-handler"
  allowed_policies = [vault_policy.dr_secondary_promotion.name]
  orphan           = true
  renewable        = false
  token_type       = "batch"
  token_max_ttl    = 0
}


