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
> make init_instance name=dark-grass parent_domain=scw.wescale.fr archi=mono
> cd inventories/hs_dark_grass
```

