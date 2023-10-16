output "dr_secondary_promotion_token" {
  sensitive = true
  value     = vault_token.dr_secondary_promotion.client_token
}


