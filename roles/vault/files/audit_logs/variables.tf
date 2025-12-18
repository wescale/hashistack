variable "namespace" {
  type = string
  default = ""
}

variable "auditlog" {
  type = object({
    type = string
    options = any
  })
  default = {
    type = "file"
    options = {
      file_path = "/opt/vault/logs/audit.log"
    }
  }
}