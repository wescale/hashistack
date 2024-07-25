# upgrade cluster

```{admonition} Use case
:class: note

* You have an existing cluster deployed via HashiStack.
* You have the unseal key and root token corresponding.
```
----
```{admonition} Be aware
:class: warning

* Always [create a snapshot](snapshot) before cluster upgrade.
* Always [be trained for a snapshot restore](restore) before cluster upgrade.

These operations should not be discovered under the stress of any live issue.
```

## Change role variable to desired version

```{code-block}
:caption: In any var file applied to hashistack_masters ansible group
---
hs_vault_version: "<your desired version>"
```
```{admonition} See also
:class: note

* [vault roles variables](/reference/roles/role_vault "Internals")
```


## Apply upgrade procedure

```{code-block}
:caption: Run upgrade
> ansible-playbook wescale.hashistack.vault_upgrade
```

The playbook will sequentially:

* upgrade cluster's follower nodes
* upgrade the leader node
* unseal the cluster

