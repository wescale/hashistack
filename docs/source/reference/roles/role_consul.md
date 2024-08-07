
```{include} ../../../../roles/consul/README.md
```

## Role defaults

* Version of the consul package to install. Used to determine which archive to install
according to the suffix, like
[in the official release repository](https://releases.hashicorp.com/consul/).
For example, valid values are: '1.16.4', '1.17.0+ent', '1.17.2+ent.fips1402', etc.
```
hs_consul_version: "1.17.2"

```
### Local paths

* Path to local directory containing secrets to be uploaded to nodes.

```
hs_consul_local_secrets_dir: "{{ hs_workspace_secrets_dir }}"
```

* Path to local directory where to download Consul binary before upload.

```
hs_consul_local_cache_dir: "{{ hs_workspace_root }}"
```

* [CONSUL ENTREPRISE] Path to local file containing the license.

```
hs_consul_local_license_file: ""

hs_consul_local_ca_cert: "{{ hs_workspace_secrets_dir }}/ca.cert.pem"
```
* Path to local node certificate.
```
hs_consul_node_cert: "{{ hs_consul_local_secrets_dir }}/self.cert.pem"
```
* Path to local node fullchain certificate.
```
hs_consul_node_cert_fullchain: "{{ hs_consul_local_secrets_dir }}/self.fullchain.cert.pem"
```
* Path to local node certificate private key.
```
hs_consul_node_cert_private_key: "{{ hs_consul_local_secrets_dir }}/self.cert.key"

hs_consul_terraform_work_dir: >-
  {{
    hs_workspace_tf_modules_dir
    | default(lookup('env', 'PWD') + '/terraform')
  }}

hs_consul_datacenter_name: "{{ hs_workspace | default('datacenter1') }}"
hs_consul_node_name: "{{ inventory_hostname | regex_replace('_', '-') }}"
hs_consul_connect_token: ~
```

* HTTPS listener

```
hs_consul_https_listen_ipv4: "0.0.0.0"
hs_consul_api_port: "8501"
```

* GRPC listener

```
hs_consul_grpc_listen_ipv4: "0.0.0.0"
hs_consul_grpc_tls_port: "8503"

hs_consul_prometheus_enabled: true
hs_consul_connect_root_pki_path: "consul_connect_pki_root"
hs_consul_connect_intermediate_pki_path: "consul_connect_pki_inter"
```
* API address of the vault service
```
hs_consul_vault_address: "https://vault.{{ hs_consul_domain }}:8200"

hs_consul_domain: "{{ public_domain }}"
hs_consul_node_fqdn: "{{ hs_consul_node_name }}.{{ hs_consul_domain }}"

hs_consul_service_fqdn: "consul.{{ hs_consul_domain }}"
hs_consul_external_url: "https://{{ hs_consul_service_fqdn }}"

hs_consul_bootstrap_expect: "{{ groups[hs_consul_inventory_masters_group] | length }}"
hs_consul_advertise_addr: "{{ ansible_default_ipv4.address }}"

hs_consul_use_custom_ca: false

hs_consul_acl_default_policy: deny
hs_consul_acl_auto_encrypt_token: ~
```

Remote location of certificates files for Consul TLS endpoints.

```
hs_consul_self_private_key: "{{ __hs_consul_tls_dir }}/self.cert.key"
hs_consul_self_certificate: "{{ __hs_consul_tls_dir }}/self.fullchain.cert.pem"
hs_consul_ca_certificate: "{{ __hs_consul_certs_truststore_dir }}/consul.ca.crt"
hs_consul_vault_root_ca_certificate: "{{ __hs_consul_certs_truststore_dir }}/vault.root_ca.crt"

hs_consul_inventory_masters_group: "hashistack_masters"
hs_consul_inventory_minions_group: "hashistack_minions"

