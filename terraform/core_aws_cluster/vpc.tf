resource "aws_vpc" "sandbox-vpc" {
  cidr_block = "172.42.0.0/16"

  assign_generated_ipv6_cidr_block = true

  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "sandbox-vpc"
  }
}

resource "aws_subnet" "sandbox-sb" {

  count = length(data.aws_availability_zones.available.names)

  vpc_id     = aws_vpc.sandbox-vpc.id
  cidr_block = "172.42.${count.index + 1}.0/24"

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch                     = false
  depends_on                                  = [aws_vpc.sandbox-vpc]
  enable_resource_name_dns_a_record_on_launch = true

  ipv6_cidr_block                 = cidrsubnet(aws_vpc.sandbox-vpc.ipv6_cidr_block, 8, count.index)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sandbox-sb-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "sandbox-igw" {
  vpc_id     = aws_vpc.sandbox-vpc.id
  depends_on = [aws_vpc.sandbox-vpc]

  tags = {
    Name = "sandbox-igw"
  }
}

resource "aws_route_table" "sandbox-rt" {
  vpc_id     = aws_vpc.sandbox-vpc.id
  depends_on = [aws_vpc.sandbox-vpc]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sandbox-igw.id
  }

  tags = {
    Name = "sandbox-rt"
  }
}

resource "aws_route_table_association" "sandbox-rta" {

  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.sandbox-sb[count.index].id
  route_table_id = aws_route_table.sandbox-rt.id
  depends_on     = [aws_route_table.sandbox-rt, aws_subnet.sandbox-sb]
}

resource "aws_vpc_dhcp_options" "sandbox-dns-resolver" {
  domain_name_servers = ["9.9.9.9", "1.1.1.1", "1.0.0.1"]

  tags = {
    Name = "sandbox-dns-resolver"
  }
}

resource "aws_vpc_dhcp_options_association" "sandbox-dns-resolver-association" {
  vpc_id          = aws_vpc.sandbox-vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.sandbox-dns-resolver.id
  depends_on      = [aws_vpc.sandbox-vpc]
}
