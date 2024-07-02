#
# Ingress: Public DNS authority service
#
resource "scaleway_vpc_public_gateway_pat_rule" "dns" {
  gateway_id   = scaleway_vpc_public_gateway.internal.id
  private_ip   = data.scaleway_ipam_ip.sre.address
  private_port = 53
  public_port  = 53
  protocol     = "both"
  depends_on   = [scaleway_instance_server.sre]
}

resource "scaleway_vpc_public_gateway_pat_rule" "http" {
  gateway_id   = scaleway_vpc_public_gateway.internal.id
  private_ip   = data.scaleway_ipam_ip.sre.address
  private_port = 80
  public_port  = 80
  protocol     = "tcp"
  depends_on   = [scaleway_instance_server.sre]
}

resource "scaleway_vpc_public_gateway_pat_rule" "https" {
  gateway_id   = scaleway_vpc_public_gateway.internal.id
  private_ip   = data.scaleway_ipam_ip.sre.address
  private_port = 443
  public_port  = 443
  protocol     = "tcp"
  depends_on   = [scaleway_instance_server.sre]
}

