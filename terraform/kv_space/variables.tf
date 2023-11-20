variable "zone" {
  type = string
}

variable "mount_point" {
  type = string
}


variable "token" {
  type = map(object({
    renewable       = optional(string)
    ttl             = optional(string)
    renew_min_lease = optional(string)
    renew_increment = optional(string)
  }))
}