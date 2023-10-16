# init

```{admonition} Goal
:class: tip

Creates a local directory with default templated variables files, ansible configuration and inventory skeleton
for managing an Hashistack deployment.
```

## Usage

```{code-block}
> ansible-playbook wescale.hashistack.init 
```

## Variables

 * Name of the environment.
```{code-block}
hs_workspace: "{{ lookup('env', 'HS_WORKSPACE') }}"
```
----

* The parent DNS domain of the service that will be exposed.
```{code-block}
hs_parent_domain: "{{ lookup('env', 'HS_PARENT_DOMAIN') }}"
```
----

* The local directory that will become parent of the generated directory.
```{code-block}
hs_base_dir: "{{ lookup('env', 'PWD') }}"
```
----

* The type of desired deployment:
    * `mono` for single node deployment
    * `multi` for cluster deployment

```{code-block}
hs_archi: "{{ lookup('env', 'HS_ARCHI') }}"
```
----

* The name of the generated hashistack directory.
```{code-block}
hs_dir_name: "{{ hs_workspace | regex_replace('-','_') }}"
```

