# création & gesion des ns enfant (4 niveau)
# path "admin/+/+/sys/namespaces*" {
#   capabilities = ["create","update","read", "list"]
# }

# Create and manage ACL policies broadly across Vault

# List existing policies
path "admin/+/sys/policies/acl" {
  capabilities = ["list"]
}

# Create and manage ACL policies
path "admin/+/sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage authentication methods broadly across Vault
# Allow managing leases
path "admin/+/sys/leases/*" {
  capabilities = ["read", "update", "list","sudo"]
}


# # Manage auth methods broadly across Vault
path "admin/+/auth/*" {
  capabilities = [ "create", "read", "update", "delete", "list",]
}

# List auth methods
path "admin/+/sys/auth" {
  capabilities = ["read"]
}

# Manage identity
path "admin/+/identity/entity*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "admin/+/identity/group*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "admin/+/identity/lookup/group" {
  capabilities = ["read","list"]
}

path "admin/+/identity/lookup/identity" {
  capabilities = ["read","list"]
}

# Manage secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# List existing secrets engines.
path "sys/mounts" {
  capabilities = ["create", "read", "update", "delete", "list"]
}