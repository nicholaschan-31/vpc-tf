#vpc
resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.name}-vpc"
  }
}

#igw
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-igw"
  }
}

#subnets
resource "aws_subnet" "main_public_subnet" {
  count = length(var.public_subnet)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet[count.index].cidr
  availability_zone       = var.public_subnet[count.index].az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "main_private_subnet" {
  count = length(var.private_subnet)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet[count.index].cidr
  availability_zone = var.private_subnet[count.index].az

  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

#rtb
resource "aws_route_table" "main_public_rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-public-rtb"
  }
}

resource "aws_route_table" "main_private_rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-private-rtb"
  }

}

#route
resource "aws_route" "main_public_route" {
  route_table_id         = aws_route_table.main_public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

#rtb association
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.main_public_subnet)

  subnet_id      = aws_subnet.main_public_subnet[count.index].id
  route_table_id = aws_route_table.main_public_rtb.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.main_private_subnet)

  subnet_id      = aws_subnet.main_private_subnet[count.index].id
  route_table_id = aws_route_table.main_private_rtb.id
}

#interface endpoint for ssm
resource "aws_vpc_endpoint" "ssm" {
  count              = length(var.endpoint_service_name)
  vpc_id             = aws_vpc.main.id
  service_name       = var.endpoint_service_name[count.index]
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.main_private_subnet[0].id]
  security_group_ids = [aws_security_group.interface_endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "${var.name}-${count.index + 1}"
  }
}

#sg
resource "aws_security_group" "standard_sg" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "carapp-standard-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_lb_sg" {
  security_group_id = aws_security_group.standard_sg.id
  cidr_ipv4         = aws_vpc.lb_sg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.standard_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "carapp-lb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_lb_sg" {
  security_group_id = aws_security_group.standard_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_group_egress_rule" "allow_standard_sg" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = aws_security_group.standard_sg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group" "interface_endpoint" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "interface-endpoint-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_interface_endpoint" {
  security_group_id = aws_security_group.interface_endpoint.id
  cidr_ipv4         = aws_security_group.standard_sg.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}


