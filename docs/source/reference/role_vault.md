
```{include} ../../../roles/vault/README.md
```

## Defaults

* Version of the vault package to install.
```
hs_vault_version: "1.12.2-1"
```
* Domain under which vault will be published on the network
```
hs_vault_domain: "{{ public_domain }}"
```

* Name of the vault cluster
```
hs_vault_cluster_name: "{{ hs_workspace }}"
```

* Path on the ansible controller where secrets are to be stored.
```
hs_vault_local_secret_dir: "{{ hs_workspace_secrets_dir }}"
```

* Name of the vault node. MUST be different for every node in the cluster.
```
hs_vault_node_name: "{{ inventory_hostname | regex_replace('_', '-') }}"
```

* FQDN of the node on the network. MUST be different for every node in the cluster. MUST
be solvable by any of the other nodes in the cluster.
```
hs_vault_node_fqdn: "{{ hs_vault_node_name }}.{{ hs_vault_domain }}"
```

* Name of the ansible inventory group that contain all master nodes.
```
hs_vault_inventory_masters_group: "hashistack_masters"
```

* Protocol of the exposed API.
```
hs_vault_api_protocol: "https"
```

* API address.
```
hs_vault_api_address: "{{ hs_vault_node_fqdn }}"
```

* API port number.
TODO: Rename to 'listen'
```
hs_vault_api_port: "8200"
```

* IPv4 interface to expose API.
```
hs_vault_listen_ipv4: "{{ ansible_default_ipv4.address }}"

hs_vault_api_listener: "{{ hs_vault_listen_ipv4 }}:{{ hs_vault_api_port }}"

hs_vault_external_url: "https://vault.{{ hs_vault_domain }}"

hs_vault_cluster_protocol: "https"
hs_vault_cluster_address: "{{ hs_vault_node_fqdn }}"
hs_vault_cluster_port: "8201"
hs_vault_cluster_listener: "{{ hs_vault_listen_ipv4 }}:{{ hs_vault_cluster_port }}"
```

### Certificates

```
hs_vault_use_custom_ca: false
#hs_vault_node_ca_cert: "{{ hs_vault_local_secret_dir }}/self.ca.cert.pem"
hs_vault_node_cert: "{{ hs_vault_local_secret_dir }}/self.cert.pem"
hs_vault_node_cert_private_key: "{{ hs_vault_local_secret_dir }}/self.cert.key"
hs_vault_node_cert_fullchain: "{{ hs_vault_local_secret_dir }}/self.fullchain.cert.pem"
```

### Unseal

```
hs_vault_unseal_method: "in-place"
hs_vault_unseal_key_shares: 5
hs_vault_unseal_key_threshold: 3
hs_vault_local_unseal_file: "{{ hs_vault_local_secret_dir }}/root_vault.yml"
hs_vault_local_ca_cert: "{{ hs_vault_local_secret_dir }}/ca.cert.pem"

hs_vault_terraform_work_dir: "{{ hs_workspace_tf_modules_dir }}"

packages_list:
  - "vault={{ hs_vault_version }}"
