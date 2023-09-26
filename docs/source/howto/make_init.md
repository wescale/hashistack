# Init an hashistack instance

This how-to will lead you to initiate a local directory with the right directory structure
in preparation for a deployment.

```{admonition} Cluster size matters
:class: important

If you want to deploy a multi-node instance, replace `archi=mono` with `archi=multi` in the first step.
```

```{code-block}
:name: init-instance
:caption: Initiate an instance directory

> ansible-playbook wescale.hashistack.00_init_instance \
> -e hs_workspace=${HS_WORKSPACE_NAME} \
> -e hs_parent_domain=${HS_PARENT_DOMAIN} \
> -e hs_archi=[multi|mono]

> cd inventories/hs_${HS_WORKSPACE_NAME}
```

