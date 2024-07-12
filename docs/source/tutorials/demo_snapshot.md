# Vault snapshot

#### Other dir


ansible-playbook wescale.hashistack.vault_snapshot

```
> tree -a
.
├── ansible.cfg
├── backups
│   └── vault
│       ├── duplicity-full.20240710T131419Z.manifest.gpg
│       ├── duplicity-full.20240710T131419Z.vol1.difftar.gpg
│       └── duplicity-full-signatures.20240710T131419Z.sigtar.gpg
├── group_vars
│   ├── all.yml
│   └── hashistack
│       └── secrets
│           ├── default.key
│           ├── default.key.pub
│           └── vault_addon_snapshot.yml
├── inventory
└── ssh.cfg
```

### Main dir

ansible -m shell -b -a "systemctl stop vault && rm -rf /opt/vault" hashistack_masters

#### Keep aside unseal keys k linked to snapshot data

mv group_vars/hashistack/secrets/root_vault.yml ./

ansible-playbook wescale.hashistack.20_vault_install

### Backup dir

ansible-playbook wescale.hashistack.vault_restore

### Main dir

cp root_vault.yml group_vars/hashistack/secrets/root_vault.yml
ansible-playbook wescale.hashistack.20_vault_install


