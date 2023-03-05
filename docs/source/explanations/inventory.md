# Inventory structure

```{code-block}
_ hashistack
  \_ hashistack_sre
  \_ hashistack_cluster
     \_ hashistack_masters
     \_ hashistack_minions
```

![inventory structure](/images/inventory.png)

To get a single node architecture, you have to make your host be a member of:

* hashistack_sre
* hashistack_masters
* hashistack_minions

...all at once.
