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
  security_group_ids = var.security_group_id

  private_dns_enabled = true

  tags = {
    Name = "${var.name}-${count.index + 1}"
  }
}





