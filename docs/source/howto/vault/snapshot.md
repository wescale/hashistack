# snapshot

```{admonition} Use case
:class: note

* You have an existing cluster deployed via HashiStack.
* You want to retrieve Vault data snapshots.
```

## Work assumptions

In this picture, we have 3 types of hosts:

* The Ansible Controller, that has access to root secrets and can configure the Vault cluster.
* The `hashistack_masters` hosts that run the Vault service.
* The Snapshot Host, that need to ssh into the `hashistack_masters` hosts to create and retrieve a snapshot.

## Prepare Snapshot Host

### Install

On the snapshot host: 

* [Install hashistack](/tutorials/install)
* Create an ssh keypair for connection on the Vault master hosts.
* Keep aside the public key value for next step.

## Prepare hashistack_masters


### Install the `snapshot` vault add-on

From the ansible controller.

```{code-block}
:caption: In your ansible group variables for hashistack_masters
hs_vault_enabled_addons:
  - "snapshot"

hs_vault_addon_snapshot_authorized_keys:
  - "<value of Snapshot Host's public key>"
```

```{code-block}
:caption: Run
ansible-playbook wescale.hashistack.vault -t addons
```

## Finalize Snapshot Host

At this stage:

* The snapshot public key is authorized onto the hashistack_masters hosts.
* The user for snapshot connection is currently hardcoded as `vault-snapshot`
* The Vault cluster is configured with a policy to allow snapshot operations.

Now you have to fill the blanks __on the Snapshot Host__ to have a directory looking like this:

```{code-block}
:caption: Snapshot directory content
.
├── ansible.cfg
├── group_vars
│   └── all.yml
├── inventory
├── keys
│   ├── bastion.key                 # optionnal: key for proxyjump traversal
│   ├── hs_vault_snapshot.key       # key to connect hashistack masters
│   └── hs_vault_snapshot.key.pub   # content allowed in hashisatck_masters
└── ssh.cfg
```
```{code-block}
:caption: ansible.cfg - At least this to make default options silent
[defaults]
inventory = inventory

[ssh_connection]
ssh_args = -F ssh.cfg
```
```{admonition} No negociation
:class: warning
It's important that all connection options go to this `ssh.cfg` host as collection implementation
for file synchronization rely on the `ansible.posix.synchronize` module (rsync-based) and on 
presence of this ssh config file.
```

```{code-block}
:caption: group_vars/all.yml - Bare miminum for collection playbooks
---
# Find these values in your Ansible Controller's var file:
#   group_vars/all.yml
hs_workspace: "<...>"
hs_parent_domain: "<...>"

# Find this value in your Ansible Controller's var file:
#   group_vars/hashistack/secrets/vault_addon_snapshot.yml
hs_vault_snapshot_token: "<...>"
```

```{code-block}
:caption: inventory - Group structure and hashistack_masters hosts
localhost ansible_connection=local

[hashistack:children]
hashistack_cluster

[hashistack_cluster:children]
hashistack_masters

[hashistack_masters]
...-master-1
...-master-2
...-master-3
```

## Operations

On the Snapshot Host:

```{code-block}
:caption: Validate connectivity
> ssh -F ssh.cfg ...-master-1 exit && echo 'OK' || echo 'KO'
OK
> ansible -m ping hashistack_masters
```

```{code-block}
:caption: Get a snapshot
> ansible-playbook wescale.hashistack.vault_snapshot
```

The content of you Snapshot Host directory should now look like:

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

Repeat the last command to pile up snapshot files in the `backups` directory.

----

```{admonition} To ensure restoration
:class: warning
To restore these snapshot, __you will need the corresponding unseal keys__ 
(stored in `group_vars/hashistack/secrets/root_vault.yml` by default). Be sure to manage there
lifecycle properly to be able to match a snapshot with the correct version of the unseal keys.
```

