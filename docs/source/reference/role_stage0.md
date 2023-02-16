
```{include} ../../../roles/stage0/README.md
```

## Role defaults

The only provider supported so far is the default.

```

hs_stage0_provider: "scaleway"
```

Architecture comes in 2 flavors: [mono|multi]

```

hs_stage0_archi: "multi"

tf_module_name: "core_scw_{{ hs_archi }}"
