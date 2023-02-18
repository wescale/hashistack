# Deploy stages

This stack's deployment has been designed in successive phases that have to be done in the right order for a platform
to become functional. This section describes the different stages that lead to a full deployment.

## Preparation

We believe strongly into a clear separation between automation code and the dataset 
that dictates its behavior.

That is why every instanciation of an hashistack should be packaged into its own directory
with:

* inventory
* ssh configuration
* group and host variables files

We supply a command line for creating the directories and files we rely on in the next 
deploy phases:

* `make init_instance`
* ...which calls on the playbook `playbooks/00_init_instance.yml`

Invocating this should give you a directory under `inventories/` with everythin in place
ready for the next phases.

```{admonition} Take-away
:class: important
Every other operations on an hashistack instance should be run from the inside of
the `inventories/hs_<NAME>` directory.
```

## Stage 0 - Infrastructure 

This stage is about creating the mandatory infrastructure resources. 
It is about network, hosts, default accounts, load balancers, and getting them ready for
hashistack installation.

At the end of this stage you must have a clean ansible inventory an ssh configuration
and the variables files pointing filled with all the necessary.

For our demo case you can rely on:

* the command `make stage_0_scaleway`
* ...which calls on the playbook `playbooks/01_infra_scaleway.yml`
* ...which invokes the [](/reference/role_stage0.md) role

...to achieve this phase.


```{admonition} Take-away
:class: important
Depending on your target infrastructure, this phase is to be adapted. Refer to 
the guide How-to [](/howto/adapt_infra.md)
```


## Stage 1 - System services

installation and configuration (NTP, SSH, DNS, ...)

## Stage 2 - Vault and Consul

installation and configuration

## Stage 3 - Nomad

installation and configuration

## Stage 4 - SRE tooling

installation and configuration
