```{include} ../../../roles/infra/README.md
```

## Role defaults

Name of the hashistack instance.
```
hs_infra_workspace: "{{ hs_workspace }}"

```
The only provider supported so far is the default.
```
hs_infra_flavor: "scw_one"

```
Directory in which the role will copy its terraform module sources.
```
hs_infra_tf_modules_dir: "{{ hs_tf_modules_dir }}"

```
## Terraform variables

Atomic configuration variables for all flavors.
```
hs_infra_private_key_file: "{{ hs_ssh_private_key_file }}"
hs_infra_local_secrets_dir: "{{ hs_secrets_dir }}"
hs_infra_local_hs_group_vars_dir: "{{ hs_group_vars_root_dir }}/toc"
hs_infra_local_keepers_group_vars_dir: "{{ hs_group_vars_root_dir }}/hs_keepers"
hs_infra_local_watchers_group_vars_dir: "{{ hs_group_vars_root_dir }}/hs_watchers"
hs_infra_local_workers_group_vars_dir: "{{ hs_group_vars_root_dir }}/hs_workers"
hs_infra_local_expected_dirs:
  - "{{ hs_infra_local_secrets_dir }}"
  - "{{ hs_infra_local_hs_group_vars_dir }}"
  - "{{ hs_infra_local_keepers_group_vars_dir }}"
  - "{{ hs_infra_local_watchers_group_vars_dir }}"
  - "{{ hs_infra_local_workers_group_vars_dir }}"

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

