# SSH to nodes

If you followed the tutorial [](/tutorials/deploy_scw.md) it could be some
sort of auto-magic going on. This guide will help you connecting to the created nodes.

## Straightforward answer

* Starting at the project directory level.

```{code-block}
:caption: If archi is `mono`
> cd inventories/hs_<INSTANCE_NAME>
> ssh -F ssh.cfg <INSTANCE_NAME>-mono
```

```{code-block}
:caption: If archi is `multi`
> cd inventories/hs_<INSTANCE_NAME>
> ssh -F ssh.cfg <INSTANCE_NAME>-sre
> ssh -F ssh.cfg <INSTANCE_NAME>-master-01
> ssh -F ssh.cfg <INSTANCE_NAME>-minion-01
```
## Reveal the magic

* Starting at the project directory level.
* Place your terminal in the instance directory:

```{code-block}
> cd inventories/hs_<INSTANCE_NAME>
```

Node naming differ depending on the archi your created, be it `mono` or `multi` nodes.
The node names are listed in the `inventory` file. To get the node names you can:

```{code-block}
> cat inventory
#
# Inventory for Hashistack instance: grass
#
# Playbooks rely on predefined groups hierarchy:
#
# _ hashistack
#   \_ hashistack_sre
#   \_ hashistack_cluster
#      \_ hashistack_masters
#      \_ hashistack_minions
#
localhost ansible_connection=local
#
# BEGIN-hs-stage0-grass
[hashistack:children]
hashistack_cluster
hashistack_sre

[hashistack_cluster:children]
hashistack_masters
hashistack_minions

[hashistack_sre]
grass-sre

[hashistack_masters]
grass-master-01
grass-master-02
grass-master-03

[hashistack_minions]
grass-minion-01
grass-minion-02
grass-minion-03
# END-hs-stage0-grass
```

All the ssh connection parameters are configured in the `ssh.cfg` file.

```{code-block}
> cat ssh.cfg
#
# SSH configuration for Hashistack instance: grass
#
# BEGIN-hs-stage0-grass
Host grass-sre
  Hostname [...]

Host grass-master-01
  Hostname [...]

Host grass-master-02
  Hostname [...]

Host grass-master-03
  Hostname [...]

Host grass-minion-01
  Hostname [...]

Host grass-minion-02
  Hostname [...]

Host grass-minion-03
  Hostname [...]

Host grass-master-* grass-minion-*
  ProxyJump grass-sre

Host grass-*
  User caretaker
  IdentityFile          ./group_vars/hashistack/secrets/default.key
  StrictHostKeyChecking no
  UserKnownHostsFile    /dev/null
  ControlMaster         auto
  ControlPath           ~/.ssh/mux-%r@%h:%p
  ControlPersist        15m
  ServerAliveInterval   100
  TCPKeepAlive          yes
# END-hs-stage0-grass
```

```{admonition} Note
:class: note

The [stage_1](/explanations/stages.md) creates a dedicated service user (by default named `caretaker`)
with `NOPASSWD:ALL` sudoer rights, along with a dedicated keypair. Also it configures `sshd` to
forbid direct ssh connection for the user `root`.
```
