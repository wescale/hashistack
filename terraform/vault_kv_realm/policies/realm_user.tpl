
path "${kv_v2_mount_point}/data/${realm_name}/*" {
  capabilities = ["read"]
}

path "${kv_v2_mount_point}/metadata/${realm_name}" {
  capabilities = ["read", "list"]
}

path "${kv_v2_mount_point}/metadata/${realm_name}/*" {
  capabilities = ["read", "list"]
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

