variable "namespace" {
  type = list(object({
    name = string
    parent = string
    policies = list(string)
  }))
}
