variable "namespace" {
  type = string
  default = ""
}

variable "secret" {
  type = list(object({
    name = string
    conf = object({
      description = string
      config = object({
        max_versions = number
        delete_version_after = number
      })
    })
  }))
}