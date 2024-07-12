# Install Vault cluster

## Goals

* Use Scaleway as Cloud Service Provider.
* Deploying a Vault cluster instance.
* Deploy a SRE instance aside for tooling.


## Prerequisites

* [Install HashiStack](/tutorials/install.md).
* [Setup your Scaleway credentials](/howto/setup_scw_creds.md).
* Manage a [DNS domain ready](https://www.scaleway.com/en/docs/network/domains-and-dns/how-to/add-external-domain/) in your Scaleway account. For our examples, the domain will be `scw.wescale.fr`.
* Name for your deployment. For the example we will name it `epic`.


## Steps

```{code-block}
:caption: Initiate an HashiStack instance directory
> ansible-playbook wescale.hashistack.init \
>     -e hs_parent_domain=scw.wescale.fr   \
>     -e hs_workspace=epic
> cd epi
```

```{code-block}
:caption: Create Scaleway infrastructure and DNS delegation
> ansible-playbook wescale.hashistack.01_infra
```

```{code-block}
:caption: Bootstrap servers to system readiness
> ansible-playbook wescale.hashistack.11_core_bootstrap
```

```{code-block}
:caption: Setup DNS authority, LetsEncrypt certificates and reverse-proxy
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

    * [https://vault.epic.scw.wescale.fr](https://vault.epic.scw.wescale.fr)

* To log into these web interfaces you need to [use the root Vault token](/howto/find_root_tokens.md).


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

