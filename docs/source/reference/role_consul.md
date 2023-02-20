
```{include} ../../../roles/consul/README.md
```

## Defaults

```
tf_module_name: "consul_config"
tf_action: apply

consul_datacenter_name: "{{ hs_workspace }}"
consul_version: "1.14.4-1"
consul_connect_token: ~
consul_inventory_masters_group: "hashistack_masters"
consul_inventory_minions_group: "hashistack_minions"

consul_prometheus_enabled: true
consul_connect_root_pki_path: "connect_root"
consul_connect_intermediate_pki_path: "connect_inter"

consul_vault_address: "https://vault.{{ hs_consul_domain }}:8200"
hs_consul_api_port: "8501"
hs_consul_grpc_port: "8502"
hs_consul_grpc_tls_port: "8503"
consul_address: "https://127.0.0.1:{{ hs_consul_api_port }}"



hs_consul_node_name: "{{ inventory_hostname | regex_replace('_', '-') }}"
hs_consul_domain: "{{ public_domain }}"
hs_consul_node_fqdn: "{{ hs_consul_node_name }}.{{ hs_consul_domain }}"

hs_consul_external_url: https://consul.{{ hs_consul_domain }}


consul_bootstrap_expect: "{{ groups[consul_inventory_masters_group] | length }}"
consul_advertise_addr: "{{ ansible_default_ipv4.address }}"

consul_use_custom_ca: false
consul_local_ca_cert: "{{ hs_workspace_secrets_dir }}/ca.cert.pem"

consul_acl_default_policy: deny
consul_acl_auto_encrypt_token: ~
consul_ca_certificate_dir: "/usr/local/share/ca-certificates"
consul_ca_certificate: "/etc/ssl/certs/ca-certificates.crt"
consul_local_secrets_dir: "{{ hs_workspace_secrets_dir }}"
consul_node_cert: "{{ consul_local_secrets_dir }}/self.cert.pem"
consul_node_cert_private_key: "{{ consul_local_secrets_dir }}/self.cert.key"
consul_node_cert_fullchain: "{{ consul_local_secrets_dir }}/self.fullchain.cert.pem"

