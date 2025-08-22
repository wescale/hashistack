locals {
  policies = flatten([
    for key, val in var.namespace : [
      for pol in val.policies : {
        nsk    = val.name
        ns     = vault_namespace.namespace[val.name].path_fq
        policy = pol
      }
    ]
  ])
}

resource "vault_namespace" "namespace" {
    for_each = { for k,v in var.namespace: v.name => v }
    path      = each.value.name
    namespace = (each.value.parent == "" || each.value.parent == "root")  ? null : substr(each.value.parent,0,-1)
}

resource "vault_policy" "policy" {
  for_each = { for pol in local.policies: "${pol.nsk}-${pol.policy}" => pol }
  name   = each.value.ns
  policy = file("${path.module}/policies/${each.value.policy}.hcl")
}