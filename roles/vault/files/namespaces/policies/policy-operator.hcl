# Read system health check
path "sys/health" {
  capabilities = ["read", "sudo"]
}

# Read system health check
path "sys/metrics" {
  capabilities = ["read"]
}

# Audit
path "sys/audit*" {
  capabilities = ["read", "list", "sudo"]
}

# Gestion Namespace
path "sys/namespaces*" {
  capabilities = ["read", "list"]
}

# CLUSTER
path "sys/ha-status" {
  capabilities = ["read"]
}

# Monitoring
path "sys/internal/counters*" {
  capabilities = ["read", "list", "sudo"]
}

path "sys/replication/*" {
  capabilities = ["read", "list", "sudo"]
}

# Manage raft storage and snapshot

path "sys/storage/raft/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "identity/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Create and manage ACL policies broadly across Vault

# List existing policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

# Create and manage ACL policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage authentication methods broadly across Vault
# Allow managing leases
path "sys/leases/*" {
  capabilities = ["read", "update", "list"]
}
 
# Manage auth methods broadly across Vault
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth" {
  capabilities = ["read"]
}

# Manage secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts" {
  capabilities = ["read"]
}
 
# Configure License
path "sys/license" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
 
# Configure Vault UI
path "sys/config/ui" {
  capabilities = ["read", "update", "delete", "list"]
}

# DR config
# To enable DR primary
path "sys/replication/dr/primary/enable" {
  capabilities = ["create", "update"]
}

# To generate a secondary token required to add a DR secondary
path "sys/replication/dr/primary/secondary-token" {
  capabilities = ["create", "update", "sudo"]
}

# To demote the primary to secondary
path "sys/replication/dr/primary/demote" {
  capabilities = ["create", "update"]
}

# To enable DR secondary
path "sys/replication/dr/secondary/enable" {
  capabilities = ["create", "update"]
}

# To generate an operation token
path "sys/replication/dr/secondary/generate-operation-token/*" {
  capabilities = ["create", "update"]
}

# To promote the secondary cluster to be primary
path "sys/replication/dr/secondary/promote" {
  capabilities = ["create", "update"]
}

# To update the assigned primary cluster
path "sys/replication/dr/secondary/update-primary" {
  capabilities = ["create", "update"]
}

# If you choose to disable the original primary cluster post-recovery
path "sys/replication/dr/primary/disable" {
  capabilities = ["create", "update"]
}

# DELEGATION DE DROIT POUR INCIDENT (batch token voir doc: https://developer.hashicorp.com/vault/tutorials/enterprise/disaster-recovery#dr-operation-token-strategy)
# Create a token role for batch DR operation token
# path "auth/token/roles/*" {
#   capabilities = ["create", "update"]
# }

# # Create a token
# path "auth/token/create" {
#   capabilities = ["create", "update"]
# }

