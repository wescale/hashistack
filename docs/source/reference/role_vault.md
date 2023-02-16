
```{include} ../../../roles/vault/README.md
```

## Defaults

```

tf_module_name: "vault_config"
tf_action: apply

vault_cluster_name: "{{ hs_workspace }}"
vault_version: "1.12.2-1"

vault_inventory_masters_group: "hashistack_masters"
vault_inventory_minions_group: "hashistack_minions"

vault_api_protocol: "https"
vault_api_address: "{{ inventory_hostname }}"
vault_api_port: "8200"
vault_api_listener: "0.0.0.0:8200"

vault_cluster_protocol: "https"
vault_cluster_address: "{{ inventory_hostname }}"
vault_cluster_port: "8201"
vault_cluster_listener: "0.0.0.0:8201"

vault_master_partners: >-
  {{
    groups[vault_inventory_masters_group]
    | difference([inventory_hostname])
    | map('regex_replace', '_', '-')
  }}
```

### Another theme

```

vault_node_cert: "{{ host_secrets_dir }}/self.cert.pem"
vault_node_cert_private_key: "{{ host_secrets_dir }}/self.cert.key"
vault_node_cert_fullchain: "{{ host_secrets_dir }}/self.fullchain.cert.pem"

vault_local_unseal_file: "{{ hs_workspace_secrets_dir }}/unseal.yml"

vault_use_custom_ca: true
vault_local_ca_cert: "{{ hs_workspace_secrets_dir }}/ca.cert.pem"

vault_unseal_method: "in-place"
```

Related to
[service_registration stanza](https://developer.hashicorp.com/vault/docs/configuration/service-registration)

```

vault_service_registration_address: ~

vault_unseal_key_shares: 5
vault_unseal_key_threshold: 3
