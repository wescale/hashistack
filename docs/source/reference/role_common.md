```
tf_action: apply

hs_public_domain: >-
  {{ hs_workspace | regex_replace('_', '-') }}.{{ hs_parent_domain }}

```
ID of the vault node. MUST be different for every node in the cluster.
```
hs_node_id: >-
  {{ inventory_hostname | regex_replace('_', '-') }}

```
* FQDN of the node on the network. MUST be different for every node in the cluster. MUST
be solvable by any of the other nodes in the cluster.

```
hs_node_fqdn: >-
  {{ hs_node_id }}.{{ hs_public_domain }}

