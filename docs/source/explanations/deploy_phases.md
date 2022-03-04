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

## Phase 1: Core

Deploys system requirements and certificates that will be used by HashiStack components.

## Phase 2: Vault

Deploys Vault, unseal it, initializes a Consul Service Mesh CA and make it be trusted by all hosts.

## Phase 3: Consul

Deploys Consul, bootstraps ACL and creates a general policy for Nomad integration.

## Phase 4: Nomad

Deploys Nomad and configure it so in order to have Vault and Consul integrations.
