locals {
  parent = (var.parent == "" || var.parent == "root")  ? null : replace(var.parent, "#/$#", "")
}

output "test" {
  value = local.parent
}

resource "vault_namespace" "namespace" {
    count = (var.namespace == "" || var.namespace == "root") ? 0 : 1
    
    path      = replace(var.namespace, "#/$#", "")
    namespace = local.parent
}

resource "vault_policy" "policy" {
  for_each = toset(var.policies)
  
  namespace = (var.namespace == "" || var.namespace == "root") ? null : vault_namespace.namespace[0].path_fq
  name   = each.key
  policy = file("${path.module}/policies/${each.key}.hcl")
}