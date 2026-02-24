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
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_public_subnet
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet"
  }
}

resource "aws_subnet" "main_public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_public_subnet_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet2"
  }
}

resource "aws_subnet" "main_private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block_private_subnet
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.name}-private-subnet"
  }
}

#rtb
resource "aws_route_table" "main_public_rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-public-rtb"
  }

}

resource "aws_route_table" "main_public_rtb_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-public-rtb_2"
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

resource "aws_route" "main_public_route_2" {
  route_table_id         = aws_route_table.main_public_rtb_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id

}

#rtb association

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.main_public_rtb.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.main_public_subnet_2.id
  route_table_id = aws_route_table.main_public_rtb_2.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.main_private_subnet.id
  route_table_id = aws_route_table.main_private_rtb.id
}

#interface endpoint for ssm
resource "aws_vpc_endpoint" "ssm" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.ap-southeast-5.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_id          = aws_subnet.main_private_subnet.id
  security_group_ids = var.security_group_id

  private_dns_enabled = true

  tags = {
    Name = "${var.name}-endpoint-ssm"
  }

}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.ap-southeast-5.ssmmessages"
  vpc_endpoint_type  = "Interface"
  subnet_id          = aws_subnet.main_private_subnet.id
  security_group_ids = var.security_group_id

  private_dns_enabled = true

  tags = {
    Name = "${var.name}-endpoint-ssm-messages"
  }

}




