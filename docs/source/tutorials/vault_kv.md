# Vault KV realm

```{admonition} Important
:class: tip

This tutorial will guide you into deploying the sample policy management provided by the project.

This is NOT the only way to manage policies, it illustrates only a naive but operating implementation
for a first use case of:

* creating a kv space dedicated to an application
* creating a policy for an `admin` profile that will manage secrets in this kv space (rw)
* creating a policy for an `user` profile that will consume secrets in this kv space (ro)
```

## Prerequisites

* Have a running vault cluster (See also: [](deploy_scw.md))
* Know your vault service FQDN (See also: []())
* Know your vault root token (See also: [](../howto/find_root_tokens.md))

## Steps

### As root: Create a global policy manager



### As Policy Manager: Create a kv realm


```{admonition} Achievement Unlocked
:class: important

You now have a delegatable KV realm for applications.
```

