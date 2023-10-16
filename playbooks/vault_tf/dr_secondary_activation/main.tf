resource "vault_policy" "dr_secondary_promotion" {
  name   = "dr_secondary_promotion"
  policy = templatefile("${path.module}/policies/dr_secondary_promotion.tpl")
}

resource "vault_token" "dr_secondary_promotion" {
  policies        = [vault_policy.dr_secondary_promotion.name]
  renewable       = true
  ttl             = "15d"
  renew_increment = "15d"
  no_parent       = true
}

