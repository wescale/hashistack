
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
```

Directory in which the role will copy its terraform module sources.
```
hs_stage0_tf_work_dir: "{{ hs_workspace_tf_modules_dir }}"
