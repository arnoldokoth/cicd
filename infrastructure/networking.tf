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

resource "aws_subnet" "public1" {
  cidr_block              = "${cidrsubnet(var.network_address_space, 8, 0)}"    # 10.1.0.0/24
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name      = "Public Subnet 1"
    Terraform = "true"
  }
}

resource "aws_subnet" "public2" {
  cidr_block              = "${cidrsubnet(var.network_address_space, 8, 1)}"    # 10.1.1.0/24
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name      = "Public Subnet 2"
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

resource "aws_route_table_association" "rta_public1" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_route_table_association" "rta_public2" {
  subnet_id      = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}
