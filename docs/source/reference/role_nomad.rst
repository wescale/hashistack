nomad
=====
::

  nomad_datacenter_name: "{{ hs_workspace }}"
  nomad_version: "1.2.6"

  nomad_inventory_masters_group: "{{ hs_workspace }}_masters"
  nomad_inventory_minions_group: "{{ hs_workspace }}_minions"
  nomad_local_secrets_dir: "{{ hs_workspace_secrets_dir }}"
  nomad_consul_address: "{{ inventory_hostname }}.{{ public_domain }}:8501"
  nomad_node_cert: "{{ nomad_local_secrets_dir }}/self.cert.pem"
  nomad_node_cert_private_key: "{{ nomad_local_secrets_dir }}/self.cert.key"
  nomad_node_cert_fullchain: "{{ nomad_local_secrets_dir }}/self.fullchain.cert.pem"
  nomad_bootstrap_expect: "3"
  nomad_master_partners: >-
    {{
      groups[nomad_inventory_masters_group]
      | difference([inventory_hostname])
    }}

  nomad_sysctl:
    - name: "net.bridge.bridge-nf-call-arptables"
      value: "1"
    - name: "net.bridge.bridge-nf-call-ip6tables"
      value: "1"
    - name: "net.bridge.bridge-nf-call-iptables"
      value: "1"
