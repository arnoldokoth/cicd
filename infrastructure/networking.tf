resource "aws_vpc" "vpc" {
  cidr_block           = "${var.network_address_space}"
  enable_dns_hostnames = "true"

  tags {
    Name      = "CI/CD VPC"
    Terraform = "true"
  }
}

# Get AZ Data
data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name      = "CI/CD IGW"
    Terraform = "true"
  }
}

resource "aws_subnet" "public" {
  cidr_block              = "${cidrsubnet(var.network_address_space, 8, 0)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name      = "Public Subnet"
    Terraform = "true"
  }
}

resource "aws_subnet" "private1" {
  cidr_block              = "${cidrsubnet(var.network_address_space, 8, 1)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name      = "Private Subnet 1"
    Terraform = "true"
  }
}

resource "aws_subnet" "private2" {
  cidr_block              = "${cidrsubnet(var.network_address_space, 8,  2)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name      = "Private Subnet 2"
    Terraform = "true"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name      = "Public Route Table"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "rta_public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.id}"

  tags {
    Name      = "CI/CD NAT Gateway"
    Terraform = "true"
  }
}

resource "aws_route_table" "rtb_private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags {
    Name      = "Private Route Table"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "rta_private1" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.rtb_private.id}"
}

resource "aws_route_table_association" "rta_private2" {
  subnet_id      = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.rtb_private.id}"
}
