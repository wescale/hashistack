resource "vault_policy" "connect_ca" {
  name = "connect_ca"

  policy = templatefile("${path.module}/policies/consul_connect_ca.tpl", {
    root_pki_path         = local.root_pki_path,
    intermediate_pki_path = local.intermediate_pki_path
    }
  )
}

resource "vault_token" "connect_ca" {
  policies  = [vault_policy.connect_ca.name]
  renewable = true
  ttl       = "15d"
  # TODO: tests around renew_min_lease and renew_increment
  no_parent = true
}
