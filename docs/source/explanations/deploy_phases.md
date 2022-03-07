# Deploy Phases

This stack's deployment has been designed in successive phases that have to be done in the right order for a platform
to become functional. This section describes the different stages that lead to a full deployment.

## Phase 0: Core

The very first step is to get, at least, to:

* 3 to 5 Debian hosts for the masters
* 1 or more Debian hosts for the minions
* Reachable via SSH
* Responding `pong` to an `ansible -m ping`
* With an Internet egress access
* A wildcard certificate that will be used for services and application security
* An inventory file structured like this:
    * `${HS_WORKSPACE}_masters` grouping master hosts
    * `${HS_WORKSPACE}_minions` grouping worker hosts
    * `${HS_WORKSPACE}_platform` that is a parent group of the 2 others

Example:
```
# Adapt HS_WORKSPACE to yours
[HS_WORKSPACE_platform:children]
HS_WORKSPACE_masters
HS_WORKSPACE_minions

[HS_WORKSPACE_masters]
# masters hosts here

[HS_WORKSPACE_minions]
# minions hosts here
```

```{admonition} See also
:class: seealso
[More on the HS_WORKSPACE concept](hs_workspace_env_var.md)
```


```{admonition} Important
:class: important

If you provide these conditions by your own means, you can skip the automation parts supplied by the 
HashiStack Project and begin directly on Phase 1.
```

Deploys system requirements and certificates that will be used by HashiStack components.


## Phase 1: Vault

* Deploy Vault
* Unseal it
* Initializes a Consul Service Mesh CA
* Make it be trusted by all hosts

## Phase 2: Consul

* Deploy Consul
* Bootstrap ACL 
* Create a general policy for Nomad integration

## Phase 3: Nomad

* Deploy Nomad
* Configure it in order to have Vault and Consul integrations

