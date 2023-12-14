# Manage backend key for vault addons

## The problem

If you are using the `s3` backend configuration for terraformed parts of the vault role, you might encounter
a problem of backend state key overlap.

## One Solution

If you look into `roles/vault/tasks/main.yml` you will find this section:

```{code-block}
:caption: roles/vault/tasks/main.yml
:linenos:
:lineno-start: 66
- name: "Include requested vault addons"
  include_tasks:
    file: "{{ role_path }}/tasks/tf_addons/_{{ _current_conf_addon }}.yml"
    apply:
      tags:
        - addons
  loop: "{{ hs_vault_enabled_addons }}"
  loop_control:
    loop_var: _current_conf_addon
  when:
    - __hs_vault_is_master
  tags:
    - addons
```

As you can read, addons are applied in a sequence and there is a `loop_var` statement.

The idea is to rely on this mechanism to handle your key dynamism. You could configure your vault 
role like in this example:

```{code-block}
:linenos:
hs_vault_terraform_backend_type: 's3'
hs_vault_terraform_backend_config:
  key: "vault_{{ _current_conf_addon | default('no_current_conf_addon') }}"
  bucket: "..."
```

In this way, when the `hs_vault_terraform_backend_config` will be evaluated during the applicance loop
the property `key` will have a different value for each loop, directly linked to the current addon being applied.

The `| default('no_current_conf_addon')` here is only to detect any evaluation outside of the applicance loop
that could occur.
