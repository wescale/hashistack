# Full Scaleway

This tutorial will guide you through:

* Creating the necessary infrastructure on Scaleway Elements
* Delegating a Scaleway-managed DNS subdomain authority to it
* Match all the prerequisites before going on with the next HashiStack [Deploy Stage](/explanations/stages.md)

## Prerequisites

Be sure to apply these workspace setup:

* [Workspace](/howto/get_started.md)
* [Scaleway credentials](/howto/init_scw.md)

## Steps

### Label your target workspace

[Define the HS_WORKSPACE environment variable.](/explanations/hs_workspace_env_var.md)

```
export HS_WORKSPACE="myhashistack"
export HS_PARENT_DOMAIN="your.tld"
```

Also, only required for this tutorial, as it implies communication with Let's Encrypt for public certificate generation.

```
export HS_WORKSPACE_EMAIL="your.email@for.lets.encrypt"
```

### Infrastructure deployment

Run:

```
make core_scw
```

This will launch:

* Scaleway resources creation
* Ansible inventory generation
* Tailored `group_vars` generation
* Host update+upgrade
* Basic system configuration

It takes around 15 minutes for a full round.

```{admonition} Digging deeper
:class: note

You can have a look at the files generated in `group_vars/${HS_WORKSPACE}` and `group_vars/${HS_WORKSPACE}_cluster`.
```

### Vault deployment

Run:

```
make vault
```

After this step has run, you should be able to run without error:

```
curl -vL https://vault.${HS_WORKSPACE}.${HS_PARENT_DOMAIN}
```

```{admonition} Digging deeper
:class: note

You can have a look at the file generated in `group_vars/${HS_WORKSPACE}/secrets/unseal.yml`.
```


### Consul deployment

Run:
```
make consul
```

After this step has run, you should be able to run without error:

```
curl -vL https://consul.${HS_WORKSPACE}.${HS_PARENT_DOMAIN}
```


```{admonition} Digging deeper
:class: note

You can have a look at the file generated in `group_vars/${HS_WORKSPACE}/secrets/root_consul.yml`.
```


### Nomad deployment

Run:
```
make nomad
```

After this step has run, you should be able to run without error:

```
curl -vL https://nomad.${HS_WORKSPACE}.${HS_PARENT_DOMAIN}
```


```{admonition} Achievement Unlocked
:class: important

Your platform is up.
```
