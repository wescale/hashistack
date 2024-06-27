# Inventory logic

This collection is based on some architectural conventions, linked to the roles
of the hosting composing the architecture.

![inventory structure overview](/images/inventory.png)

## Host groups

### `hashistack`

This is a parent group containing all hosts composing an hashistack instance.

### `hashistack_sre`

This group is tailored for a single host which responsibilities will be to:

* Reverse proxy traffic to Vault/Consul/Nomad admin WebUI
* Hold an observability storage and visualization stack (Loki, Prometheus, Grafana)
* Hold the [DNS](dns_integration.md) authority server of the deployed environment

### `hashistack_cluster`

Parent group holding `hshistack_masters` and `hashistack_minions` for targeting hosts on common
playbooks.

### `hashistack_masters`

This group is tailored for a typical 3 to 5 hosts which responsibilities will be to:

* Hold the master processes of Vault/Consul/Nomad

### `hashistack_minions`

This group is tailored for hosts which responsibilities will be to:

* Hold Consul agent for service discovery
* Hold Nomad agents for service deployments

## Single node stack

To get a single node architecture, you have to make your host be a member of:

* `hashistack_sre`
* `hashistack_masters`
* `hashistack_minions`

...all at once.
