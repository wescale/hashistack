path "${kv_v2_mount_point}/data/${realm_name}/*" {
  capabilities = ["read"]
  description  = "Allow read on secrets ${realm_name}/* path"
}

path "${kv_v2_mount_point}/metadata/${realm_name}" {
  capabilities = ["read", "list"]
  description  = "webui list secret ${realm_name} path"
}

path "${kv_v2_mount_point}/metadata/${realm_name}/*" {
  capabilities = ["read", "list"]
  description  = "Webui list secret ${realm_name} path"
}

# Allow tokens to look up their own properties
path "auth/token/lookup-self"  {
  capabilities = ["read"]
}
  
# Allow tokens to renew themselves
path "auth/token/renew-self" {
  capabilities = ["update"]
}
 
# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
  capabilities = ["update"]
}

