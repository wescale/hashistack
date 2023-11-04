
```{include} ../../../roles/vault/README.md
```

## Defaults

* Version of the vault package to install.
* Used to determine which archive to install according to the suffix like
[in the official release repository](https://releases.hashicorp.com/vault/). For example,
valid values are: '1.14.4', '1.15.0+ent', '1.14.3+ent.fips1402', etc.

```
hs_vault_version: "1.14.2"
```

* Domain under which vault will be published on the network.

```
hs_vault_domain: "{{ public_domain }}"
hs_vault_enable_cert_auth_for_join: true
```

* Name of the vault cluster. Default value should be
defined by the __inventory's__ `group_vars/hashistack/init.yml`.

```
hs_vault_cluster_name: "{{ hs_workspace }}"
```

* Path on the ansible controller where secrets are to be stored. Default value should be
defined by the __playbook's__ `group_vars/all.yml`.
```
hs_vault_local_secret_dir: "{{ hs_workspace_secrets_dir }}"
```

* ID of the vault node. MUST be different for every node in the cluster.

```
hs_vault_node_id: "{{ inventory_hostname | regex_replace('_', '-') }}"
```

* FQDN of the node on the network. MUST be different for every node in the cluster. MUST
be solvable by any of the other nodes in the cluster.

```
hs_vault_node_fqdn: "{{ hs_vault_node_id }}.{{ hs_vault_domain }}"
```

* FQDN of the vault service on the network. Typically the FQDN of the load-balancer
if any is set up.

```
hs_vault_service_fqdn: "{{ hs_vault_cluster_name }}.{{ hs_vault_domain }}"
```

* URL of the vault service. Used by Terraform from the ansible controller
to contact vault for initial configuration.
```
hs_vault_external_url: "{{ __hs_vault_api_protocol }}://{{ hs_vault_service_fqdn }}"
```

* Name of the ansible inventory group that contain all master nodes.

```
hs_vault_inventory_masters_group: "hashistack_masters"
```

* API address.

```
hs_vault_api_address: "{{ hs_vault_node_fqdn }}"
```

* IPv4 interface to listen on.

```
hs_vault_listen_ipv4: "0.0.0.0"
```

* API port number.

```
hs_vault_api_port: "8200"
```

* Cluster port number.

```
hs_vault_cluster_port: "8201"
```

### Certificates

Set this to `true` if you are using self-signed CA certificate.

```
hs_vault_use_custom_ca: false
```

Path of the certificate that are upload on the cluster nodes for
Vault endpoints.

```
hs_vault_local_ca_cert: "{{ hs_vault_local_secret_dir }}/ca.cert.pem"
hs_vault_node_cert: "{{ hs_vault_local_secret_dir }}/self.cert.pem"
hs_vault_node_cert_private_key: "{{ hs_vault_local_secret_dir }}/self.cert.key"
hs_vault_node_cert_fullchain: "{{ hs_vault_local_secret_dir }}/self.fullchain.cert.pem"
```

### Unseal method

The only supported method so far is the `in-place` method which automates a manual unseal on the cluster
and stores the generated secrets in your `{{ hs_vault_local_unseal_file }}` directory.

```{admonition} Important
:class: important
DO NOT treat this file's content lightly. It is your responsibility to `ansible-vault` it or protect it by
any mean your could find.
```

```
hs_vault_unseal_method: "in-place"
hs_vault_unseal_key_shares: 5
hs_vault_unseal_key_threshold: 3
hs_vault_local_unseal_file: "{{ hs_vault_local_secret_dir }}/root_vault.yml"
```


### Terraform configuration modules

If you like to inject a backend configuration into the generated terraform code.
Supported values: [`'s3'`]

```
hs_vault_terraform_backend_type: ''
```

This dict will be passed to each terraform module for backend configuration.

```
hs_vault_terraform_backend_config: {}
```

Ansible controller's directory to copy the terraform module before apply.

```
hs_vault_terraform_work_dir: >-
  {{
    hs_workspace_tf_modules_dir
    | default(lookup('env', 'PWD') + '/terraform')
  }}
```

Local directory where Vault release archive will be downloaded.

```
hs_vault_local_cache_dir: "{{ hs_workspace_root }}"
```

Local path to a file that will be used as licence for Vault.

```
hs_vault_local_license_file: ""
```

Flag to let the role configure Vault with initial policies dedicated to Consul
and Nomad integration.

```
hs_vault_enable_default_policies: true
```

TODO: Variabilize ca token ttl
TODO: Playbook de rotation token consul connect
TODO: Telemetry pour l'état du consul connect CA
TODO: Doc enhance: Contribute
      mettre la syntaxe ansible galaxie requirements
TODO: Doc Explanation sur le fonctionnement des certificats
TODO: How to load variables and defaults from collection role

* List of additional tested configuration modules. Any subset from: `['tf_auth_ldap']`.
See below for specific configuration variables
```
hs_vault_enabled_addons:
  - "telemetry"
<<<<<<< HEAD:roles/vault__vars__/defaults/main.yml
  - "consul_service_mesh_ca"
=======
  - "consul_ca"
>>>>>>> main:roles/vault_vars/defaults/main.yml
  - "nomad"
```

### Addon: `auth_ldap`

```
hs_vault_addon_auth_ldap_path: ''
hs_vault_addon_auth_ldap_server_url: ''
hs_vault_addon_auth_ldap_user_dn: ''
hs_vault_addon_auth_ldap_user_attr: ''
hs_vault_addon_auth_ldap_user_principal_domain: ''
hs_vault_addon_auth_ldap_discover_dn: ''
hs_vault_addon_auth_ldap_group_dn: ''
hs_vault_addon_auth_ldap_filter: ''
