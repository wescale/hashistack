

data "template_file" "nomad_server_policy" {
  template = "${file("${path.module}/nomad_server_policy.tpl")}"
#  vars = {
#    
#  }
}

resource "vault_policy" "nomad_server" {
  name = "nomad_server"
  policy = data.template_file.nomad_server_policy
}

resource "vault_token" "nomad_server" {
  policies        = [vault_policy.nomad_server.name]
  renewable       = true
  ttl             = "1h"
  no_parent       = true
  renew_min_lease = "45m"
  renew_increment = "1h"
}

