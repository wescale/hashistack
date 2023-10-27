path "auth/token/lookup-self" {
    capabilities = ["read"]
}

path "auth/token/renew-self" {
    capabilities = ["update"]
}

path "/sys/mounts" {
  capabilities = [ "read" ]
}

path "/sys/mounts/${root_pki_path}" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/${root_pki_path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/sys/mounts/${intermediate_pki_path}" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/${intermediate_pki_path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

