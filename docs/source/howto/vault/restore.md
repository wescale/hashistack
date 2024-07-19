# restore snapshot

```{admonition} Use case
:class: note

* You have an existing cluster deployed via HashiStack.
* You have [taken Vault snapshots](snapshot).
* You have the unseal key and root token corresponding
to the snapshot you want to restore.
```

## Work assumptions

In this picture, we have 3 types of hosts:

* The Ansible Controller, that has access to root secrets and can configure the Vault cluster.
* The `hashistack_masters` hosts that run the Vault service.
* The Snapshot Host, that need to ssh into the `hashistack_masters` hosts to restore a snapshot.

You should check that:

* your Snapshot Host vault token is still valid
* your Snapshot Host can ssh into `hashistack_masters`

## From Snapshot Host

If you have followed the [How-To Vault snapshot guide](snapshot), then you should have a directory
resembling this:

```{code-block}
.
├── ansible.cfg
├── backups
│   └── vault
│       └── vault.20240719T101924.snapshot
├── group_vars
│   └── all.yml
├── inventory
├── keys
│   ├── bastion.key
│   ├── hs_vault_snapshot.key
│   └── hs_vault_snapshot.key.pub
└── ssh.cfg
```

```{code-block}
:caption: Restore a snapshot
> ansible-playbook wescale.hashistack.vault_restore -e hs_vault_restore_name="vault.20240719T101924.snapshot"
```

## From Ansible Controller

Unless you restore a snapshot that has just be taken, __the restoration process will
seal the cluster__.

In order to unseal it according to the data restored, in the [instance management directory](/explanations/glossary)
be sure to:

* replace the file `group_vars/hashistack/secrets/root_vault.yml`
with the content that was valid at te time of the snapshot.

Then run:

```{code-block}
:caption: Unseal
> ansible-playbook wescale.hashistack.vault_unseal
```


