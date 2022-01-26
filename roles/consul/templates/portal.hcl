service {
  name = "portal"
  id   = "portal"
  port = 9000
  tags = ["external"]

  tagged_addresses = {
    lan = {
      address = "192.168.100.98"
      port    = 9000
    }
  }

#  check = {
#    name = "ping check"
#    args = ["ping", "192.168.100.98"]
#    interval = "30s"
#    status = "passing"
#  }
}
