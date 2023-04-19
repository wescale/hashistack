
```{include} ../../../roles/custom_ca/README.md
```

## Role defaults

* Local path where the ca certificate should be generated.

```
hs_custom_ca_certificate: "{{ hs_workspace_secrets_dir }}/ca.cert.pem"
```

* Local path where each node private key should be generated.

```
hs_custom_ca_host_private_key: "{{ hs_workspace_secrets_dir }}/self.cert.key"
```

* Local path where each node certificate should be generated.

```
hs_custom_ca_host_certificate: "{{ hs_workspace_secrets_dir }}/self.cert.pem"
```

* Local path where each node fullchain certificate should be generated.

```
hs_custom_ca_host_fullchain_certificate: "{{ hs_workspace_secrets_dir }}/self.fullchain.cert.pem"

