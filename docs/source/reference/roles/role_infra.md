```{include} ../../../../roles/infra/README.md
```

## Role defaults

* Name of the hashistack instance.
```
hs_infra_workspace: "{{ hs_workspace }}"

```
* The only provider supported so far is the default.
```
hs_infra_flavor: "scw_one"

```
* Directory in which the role will copy its terraform module sources.
```
hs_infra_tf_modules_dir: "{{ hs_workspace_tf_modules_dir }}"

```
* Local directory for secrets storage
```
hs_infra_local_secrets_dir: "{{ hs_workspace_secrets_dir }}"

```
## Terraform variables

```
hs_infra_private_key_file: "{{ hs_workspace_ssh_private_key_file }}"
hs_infra_local_hs_group_vars_dir: "{{ hs_workspace_group_vars_dir }}"
hs_infra_local_hs_sre_group_vars_dir: "{{ hs_workspace_sre_group_vars_dir }}"
hs_infra_local_expected_dirs:
  - "{{ hs_infra_local_secrets_dir }}"
  - "{{ hs_infra_local_hs_group_vars_dir }}"

```
Atomic configuration variables for outscale_one flavor.
```
hs_infra_scw_one_instance_type_master: "DEV1-S"
hs_infra_scw_one_instance_image_all: "debian_bookworm"

hs_infra_flavor_params:
  scw_one:
    parent_domain: "{{ hs_parent_domain }}"
    ssh_public_key_file: "{{ hs_infra_private_key_file }}.pub"
    instance_type_master: "{{ hs_infra_scw_one_instance_type_master }}"
    instance_image_all: "{{ hs_infra_scw_one_instance_image_all }}"

