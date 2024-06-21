# Demo Vault cluster

## Goal

This tutorial will guide you through deploying your first complete Hashistack instance
platform using Scaleway as Cloud Service Provider.


## Prerequisites

* Follow the [](/tutorials/setup_workspace.md) tutorial.
* Follow the [How-to Setup Scaleway credentials](/howto/setup_scw_creds.md) guide.
* Have a [DNS domain ready](https://www.scaleway.com/en/docs/network/domains-and-dns/how-to/add-external-domain/) in the Scaleway console.
For our example, the domain will be `scw.wescale.fr`
* Choose a name for your platform. For the example we will name it `dark-grass`.


## Steps

```{code-block} 
:caption: Initiate an instance directory
> ansible-playbook wescale.hashistack.init -e hs_parent_domain=scw.wescale.fr -e hs_workspace=epi
> cd epi
```

```{code-block}
:caption: Create infrastructure (once)
> ansible-playbook wescale.hashistack.01_infra
```

```{code-block}
:caption: Validate ansible connectivity
> ansible -b -m ping hashistack
```

```{code-block}
:caption: Bootstrap servers to system readiness (once)
> ansible-playbook wescale.hashistack.11_core_bootstrap
```

```{code-block}
:caption: Finish requirements
> ansible-playbook wescale.hashistack.12_core_setup_dns
> ansible-playbook wescale.hashistack.14_core_letsencrypt
> ansible-playbook wescale.hashistack.15_core_rproxy
```

```{code-block}
:caption: Install Vault
> ansible-playbook wescale.hashistack.20_vault_install
```

## Validate

* Check the following url list (mind about adapting the urls to your domain and instance name):

    * [https://vault.epi.scw.wescale.fr](https://vault.epi.scw.wescale.fr)

* To log into these web interfaces you need to [](/howto/find_root_tokens.md).


```{admonition} Achievement Unlocked
:class: important

You have deployed a Vault HA cluster.
```

## Cleanup

```{admonition} Boy-scout rule
:class: warning

Always clean the campground.
```

```{code-block}
> ansible-playbook wescale.hashistack.01_infra -e tf_action=destroy
```



