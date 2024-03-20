# Deploying Your Hashistack Platform with Scaleway: A Step-by-Step Guide

## Objective:

This guide is designed to help you deploy your Hashistack platform using Scaleway as your Cloud Service Provider.


## Before You Begin:

* Follow the [Hashistack install](/docs/source/tutorials/install.md) guide
* Complete the [Setup workspace](/tutorials/setup_workspace.md) tutorial.
* Follow the [How-to Setup Scaleway credentials](/howto/setup_scw_creds.md) guide.
* Make sure you have a [DNS domain ready](https://www.scaleway.com/en/docs/network/domains-and-dns/how-to/add-external-domain/) in the Scaleway console.
For our example, the domain will be `scw.wescale.fr`
* Choose a name for your platform. For the example we will name it `dark-grass`.


## Steps

1. Determine Cluster Size:
```{admonition} Cluster size matters
If you want to deploy a multi-node instance, replace `archi=mono` with `archi=multi` in the first step.
```
2. Initialize Instance Directory:
* Run the following command to set up your instance:
```{code-block} 
> make init_instance name=dark-grass parent_domain=scw.wescale.fr archi=mono
```
* Navigate into the newly created directory:
```{code-block} 
> cd dark_grass
```

3. Create and Configure Servers on Scaleway (~20 min of runtime):
```{code-block}
> make stage_0_scaleway stage_1_auto_prerequisites
```

4. Install Vault and Consul:
* Execute the following command to install Vault and Consul:
```{code-block}
> make stage_2
```

5. Install Nomad:
* Run the command to install Nomad:
```{code-block}
> make stage_3
```

6. Install SRE Tooling:
* Install the necessary SRE tools with the following command:
```{code-block}
> make stage_4
```

## Validation

* Verify that your platform is deployed correctly by checking the following URLs (remember to replace placeholders with your domain and instance name):

    * [https://vault.dark-grass.scw.wescale.fr](https://vault.dark-grass.scw.wescale.fr)
    * [https://consul.dark-grass.scw.wescale.fr](https://consul.dark-grass.scw.wescale.fr)
    * [https://nomad.dark-grass.scw.wescale.fr](https://nomad.dark-grass.scw.wescale.fr)
    * [https://grafana.dark-grass.scw.wescale.fr](https://grafana.dark-grass.scw.wescale.fr)

* To log into these web interfaces you need to [locate the root tokens](/howto/find_root_tokens.md).


Congratulations!
You have successfully deployed your runtime platform.


## Cleanup

```{admonition} Boy-scout rule
:class: warning

Follow the Boy-scout rule and ensure to clean up your environment:
```

```{code-block}
> make scaleway_destroy
```


