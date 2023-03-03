# Deploy HashiStack @Scaleway

## Goal

This tutorial will guide you through deploying your first complete Hashistack instance
platform using Scaleway as Cloud Service Provider.

## Prerequisistes

* Follow the [](/tutorials/setup_workspace.md) tutorial.
* Follow the [How-to Setup Scaleway credentials](/howto/init_scw.md) guide.
* Have a [DNS domain ready](https://www.scaleway.com/en/docs/network/domains-and-dns/how-to/add-external-domain/) in the Scaleway console.
For our example, the domain will be `scw.wescale.fr`
* Choose a name for your platform. For the example we will name it `dark-grass`.


## Steps

```{admonition} Cluster size matters
:class: important

If you want to deploy a multi-node instance, replace `archi=mono` with `archi=multi` in the first step.
```

```{code-block}
:caption: Initiate an instance directory
> make init_instance name=dark-grass parent_domain=scw.wescale.fr archi=mono
> cd inventories/hs_dark_grass
```

```{code-block}
:caption: Create and configure the servers at Scaleway (~20 min of runtime)
> make stage_0_scaleway stage_1_auto_prerequisites
```

```{code-block}
:caption: Install Vault and Consul
> make stage_2
```

```{code-block}
:caption: Install Nomad
> make stage_3
```

```{code-block}
:caption: Install SRE tooling
> make stage_4
```

## Validate

* Check the following url list (mind about adapting the urls to your domain and instance name):

    * [https://vault.dark-grass.scw.wescale.fr](https://vault.dark-grass.scw.wescale.fr)
    * [https://consul.dark-grass.scw.wescale.fr](https://consul.dark-grass.scw.wescale.fr)
    * [https://nomad.dark-grass.scw.wescale.fr](https://nomad.dark-grass.scw.wescale.fr)
    * [https://grafana.dark-grass.scw.wescale.fr](https://grafana.dark-grass.scw.wescale.fr)

* [](/howto/find_root_tokens.md)


```{admonition} Achievement Unlocked
:class: important

You have deployed the runtime platform!
```

## Cleanup

```{admonition} Boy-scout rule
:class: warning

Do not forget to clean the campground!
```

```{code-block}
> make scaleway_destroy
```


