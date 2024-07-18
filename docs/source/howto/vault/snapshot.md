# snapshot

```{admonition} Use case
:class: note

* You have an existing cluster deployed via HashiStack.
* You want to retrieve Vault data snapshots.
```

## Work assumptions

In this picture, we have 3 types of hosts:

* The ansible controller, that has access to root secrets and can configure the Vault cluster.
* The `hashistack_masters` hosts that run the Vault service.
* The snapshot host, that need to ssh into the `hashistack_masters` hosts to create and retrieve a snapshot.

## Preparation

### Install tooling on the snapshot host

On the snapshot host, create an ssh keypair for connection on the Vault master hosts.

### Install the `snapshot` vault add-on

```{code-block}
:caption: In your ansible group variables for hashistack_masters
hs_vault_enabled_addons:
  - "snapshot"

hs_vault_addon_snapshot_authorized_keys:
  - "<value of snapshot host's public key>"
```

```{code-block}
:caption: Have this run
ansible-playbook wescale.hashistack.vault -t addons
```

That will configure a

## Operation

```{code-block}
:caption: Have this run
ansible-playbook wescale.hashistack.vault_snapshot
```


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



