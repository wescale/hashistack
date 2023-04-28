
```{include} ../../../roles/nomad/README.md
```

## Defaults

```
hs_nomad_datacenter_name: "{{ hs_workspace }}"
hs_nomad_version: "1.4.7-1"

hs_nomad_consul_address: "{{ hs_hs_nomad_node_fqdn }}:8501"
hs_nomad_consul_grpc_address: "{{ hs_hs_nomad_node_fqdn }}:8502"
hs_nomad_api_port: "4646"
hs_nomad_address: "https://{{ hs_hs_nomad_node_fqdn }}:{{ hs_nomad_api_port }}"

hs_hs_nomad_domain: "{{ public_domain }}"
hs_hs_nomad_node_name: "{{ inventory_hostname | regex_replace('_', '-') }}"
hs_hs_nomad_node_fqdn: "{{ hs_hs_nomad_node_name }}.{{ hs_hs_nomad_domain }}"

hs_nomad_vault_address: "https://vault.{{ hs_hs_nomad_domain }}:8200"
hs_nomad_vault_token: ~

hs_nomad_advertise_addr: "{{ hs_hs_nomad_node_fqdn }}"

hs_nomad_inventory_masters_group: "hashistack_masters"
hs_nomad_inventory_minions_group: "hashistack_minions"
hs_nomad_local_secrets_dir: "{{ hs_workspace_secrets_dir }}"

hs_nomad_use_custom_ca: false
hs_nomad_local_ca_cert: "{{ hs_workspace_secrets_dir }}/ca.cert.pem"

hs_nomad_tls_ca_cert: "/etc/ssl/certs/ca-certificates.crt"
```

Container image used by consul connect to build sidecars and gateways when
instructed by nomad.

```
hs_nomad_connect_image_version: "v1.23.1"
hs_nomad_connect_image: "envoyproxy/envoy:{{ hs_nomad_connect_image_version }}"
```

ansible controller path where to store the root token of nomad bottstrap.

```
hs_nomad_local_secret_file: "{{ hs_workspace_secrets_dir }}/root_nomad.yml"

hs_nomad_ca_certificate_dir: "/usr/local/share/ca-certificates"
hs_nomad_ca_certificate: "/etc/ssl/certs/ca-certificates.crt"
hs_nomad_node_cert: "{{ hs_nomad_local_secrets_dir }}/self.cert.pem"
hs_nomad_node_cert_private_key: "{{ hs_nomad_local_secrets_dir }}/self.cert.key"
hs_nomad_node_cert_fullchain: "{{ hs_nomad_local_secrets_dir }}/self.fullchain.cert.pem"
hs_nomad_bootstrap_expect: "{{ groups[hs_nomad_inventory_masters_group] | length }}"
```

* Configures Nomad to keep images from stopped tasks. Switch to `true` to get Nomad to
auto clean these container images.

```
hs_nomad_docker_cleanup_image: false
```

## Volumes

Expected list objects format:
- name: ""
  path: ""
  read_only: [true|false]

```
hs_nomad_volumes: []
hs_nomad_sysctl:
  net.bridge.bridge-nf-call-arptables: "1"
  net.bridge.bridge-nf-call-ip6tables: "1"
  net.bridge.bridge-nf-call-iptables: "1"

hs_nomad_packages_list:
  - "nomad={{ hs_nomad_version }}"
