# Deploy a Vault cluster in your own infrastructure


## Prepare your hosts

* Prepare hosts and load balancer according to the [reference architecture](https://developer.hashicorp.com/vault/tutorials/day-one-raft/raft-reference-architecture#recommended-architecture) recommendations.
* Hosts should be reachable from your Ansible controller through [Public Key Authentication](https://www.ssh.com/academy/ssh/public-key-authentication).
* Depending on your requirements, comply with the [Production Hardening Guide](https://developer.hashicorp.com/vault/tutorials/operations/production-hardening).

```{admonition} End-to-end connectivity
:class: important

Especillay think about [SELinux policies](https://github.com/hashicorp/vault-selinux-policies) that could be a silent blocker, somewhat hard to debug.
```





* If you want to manage a specific mount point for vault run data, plug your storage solution on `/opt/vault`.


## Prepare your network

* Check for [network connectivity](https://developer.hashicorp.com/vault/tutorials/day-one-raft/raft-reference-architecture#network-connectivity) compliance.

```{admonition} End-to-end connectivity
:class: important

Mind about each host firewall configuration.
```

* Configure your load balancer as TCP(L4) traffic balancing.
* Integrate your hosts and load balancer into your default DNS resolution so that:
    * Ansible controller resolves each host's and load balancer FQDN
    * Each host resolves each other hosts' and load balancer's FQDN


## Build trust

* Prepare your x509 certificates for every nodes (private keys, certificates and __fullchain certificates__).
* The certificates' issuer should be trusted at the operating system level by every node (and the future clients).

```{admonition} Caveats
:class: warning

Each certificate should be issued __for both__:
* the host's fqdn
* the exposed service FQDN beared by the load balancer
```

* Have them ready on your Ansible controller.

* serverAuth, clientAuth


## Prepare your Ansible controller

* [Setup a workspace](../tutorials/setup_workspace.md)
* [Prepare a variable folder](make_init.md)


## Adjust variables


