variable "namespace" {
  type = string
  default = ""
}

variable "users" {
  type = map(object({
    policies = list(string) 
  })
  )
}

variable "passlength" {
  type = number
  default = 16
}

variable "userpass_path" {
  type = string
}

variable "userpass_default_lease_ttl" {
  type = string
  default = "7200s"
}

variable "userpass_max_lease_ttl" {
  type = string
  default = "57600s"
}

variable "mfa" {
  type = bool
  default = false
}

variable "mfa_algorithm" {
  type = string
  default = "SHA256"
}
variable "mfa_digits" {
  type = number
  default = 6
}
variable "mfa_key_size" {
  type = number
  default = 30
}
variable "mfa_period" {
  type = number
  default = 30
}