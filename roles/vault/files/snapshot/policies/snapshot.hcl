path "/sys/storage/raft/snapshot" {
  capabilities = ["read"]
}

path "/sys/leader" {
  capabilities = ["read", "list"]
}

path "/sys/storage/raft/snapshot-force" {
  capabilities = ["create", "update"]
}
