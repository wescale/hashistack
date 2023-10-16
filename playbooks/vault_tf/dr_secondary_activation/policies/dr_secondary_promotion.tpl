
path "sys/replication/dr/secondary/promote" {
  capabilities = [ "update" ]
}

# To update the primary to connect

path "sys/replication/dr/secondary/update-primary" {
capabilities = [ "update" ]
}

# Only if using integrated storage (raft) as the storage backend
# To read the current autopilot status

path "sys/storage/raft/autopilot/state" {    
  capabilities = [ "update" , "read" ]
}

