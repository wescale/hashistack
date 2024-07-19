# on-prem deployment

## Prepare your hosts

* Prepare hosts and load balancer according to the [reference architecture](https://developer.hashicorp.com/vault/tutorials/day-one-raft/raft-reference-architecture#recommended-architecture) recommendations.
* Hosts should be reachable from your Ansible controller through [Public Key Authentication](https://www.ssh.com/academy/ssh/public-key-authentication).
* Depending on your requirements, comply with the [Production Hardening Guide](https://developer.hashicorp.com/vault/tutorials/operations/production-hardening).

```{admonition} End-to-end connectivity
:class: important

Think about [SELinux policies](https://github.com/hashicorp/vault-selinux-policies) that could be a silent blocker, somewhat hard to debug.
```

* If you want to manage a specific mount point for vault run data, plug your storage solution on `/opt/vault`.


## Network

* Check for [network connectivity](https://developer.hashicorp.com/vault/tutorials/day-one-raft/raft-reference-architecture#network-connectivity) compliance.

```{admonition} End-to-end connectivity
:class: important

Mind about each host firewall configuration.
```

* Configure your load balancer as TCP(L4) traffic balancing.
* Integrate your hosts and load balancer into your default DNS resolution so that:
    * Ansible controller resolves each host's and load balancer's FQDN
    * Each host resolves each other hosts' and load balancer's FQDN


## Certificates

* Prepare your x509 certificates for every nodes (private keys, certificates and __fullchain certificates__).
* The certificates' issuer should be trusted at the operating system level by every node (and the future clients).

```{admonition} Caveats
:class: warning

Each certificate should be issued __for both__:
* the host's fqdn
* the exposed service FQDN beared by the load balancer
```

```{admonition} Caveats
:class: warning

Each certificate must have:
* Key usage
    * digitalSignature
    * keyEncipherment
* Extended key usage
    * serverAuth
    * clientAuth
```

* Have them ready on your Ansible controller.


## Prepare your Ansible controller

* [Install Hashistack](../tutorials/install.md)
* [Initialize an environment directory](/reference/playbooks/init) and place your terminal in it.
* review the generated variable files and inventory, adjust if needed.
* Check for connectivity

```{code-block}
> ansible -m ping all
```

## Install Vault

```{code-block}
> ansible-playbook wescale.hashistack.vault
```
if everything when fine, you should be able to reach the Vault web UI through your load balancer's FQDN.

