# wescale.hashistack.init

```{admonition} Purpose
:class: tip

Creates a local directory with default templated variables files, ansible configuration and inventory skeleton
for managing an Hashistack deployment.
```

## Usage

* From any directory, from which Ansible and the Hashistack collection are [installed](/tutorials/install).


```{code-block}
> ansible-playbook wescale.hashistack.init 
```


## Variables & defaults

```{code-block}
hs_workspace: "{{ lookup('env', 'HS_WORKSPACE') }}"
```
Name of this environment. That value will propagate to templatized variable files.

----
```{code-block}
hs_parent_domain: "{{ lookup('env', 'HS_PARENT_DOMAIN') }}"
```
The parent DNS domain of the service that will be exposed. That value will propagate to templatized variable files.

----
```{code-block}
hs_base_dir: "{{ lookup('env', 'PWD') }}"
```
The directory that will become parent of the generated directory.

----
```{code-block}
hs_archi: "{{ lookup('env', 'HS_ARCHI') }}"
```
The type of desired deployment:
* `mono` for single node deployment
* `multi` for cluster deployment
That will impact the rendering of variable files.

----
```{code-block}
hs_dir_name: "{{ hs_workspace | regex_replace('-','_') }}"
```
The name of the generated hashistack directory.

