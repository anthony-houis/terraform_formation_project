resource "aws_vpc" "formation_vpc" {
  cidr_block           = "10.${var.cidr_block}.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = var.Name
  }
}

resource "aws_subnet" "formation_public_subnet" {
  count                   = length(data.aws_availability_zone.available.names)
  availability_zone       = data.aws_availability_zone.available.names[count.index]
  vpc_id                  = aws_vpc.formation_vpc.id
  cidr_block              = "10.${var.cidr_block}.${10 + count.index}.0/24"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.Name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "formation_private_subnet" {
  count                   = length(data.aws_availability_zone.available.names)
  availability_zone       = data.aws_availability_zone.available.names[count.index]
  vpc_id                  = aws_vpc.formation_vpc.id
  cidr_block              = "10.${var.cidr_block}.${count.index}.0/24"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "${var.Name}-private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "formation_igw" {
  vpc_id = aws_vpc.formation_vpc.id
  tags = {
    "Name" = "${var.Name}-igw"
  }
}

resource "aws_eip" "formation_eip" {
  tags = {
    "Name" = "${var.Name}-eip"
  }
}

resource "aws_nat_gateway" "formation_nat_gateway" {
  allocation_id = aws_eip.formation_eip.id
  subnet_id     = aws_subnet.formation_public_subnet[0].id
  tags = {
    "Name" = "${var.Name}-nat-gateway"
  }
}

resource "aws_route_table" "formation_route_table_igw" {
  vpc_id = aws_vpc.formation_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.formation_igw.id
  }
  tags = {
    "Name" = "${var.Name}-route-table-IGW"
  }
}

resource "aws_route_table" "formation_route_table_natgw" {
  vpc_id = aws_vpc.formation_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.formation_nat_gateway.id
  }
  tags = {
    "Name" = "${var.Name}-route-table-NATGW"
  }
}

resource "aws_route_table_association" "formation_route_table_association" {
  count          = length(aws_subnet.formation_private_subnet)
  subnet_id      = aws_subnet.formation_private_subnet[count.index].id
  route_table_id = aws_route_table.formation_route_table_natgw.id
}