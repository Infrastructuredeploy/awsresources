# Create aws provider for aws console
provider "aws" {
  region = "us-east-1"
}

# Create Aws_vpc 
resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}

# Create Aws_subnet 
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "mysubnet"
  }
}

# Create Aws_internet_gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "internet_gateway"
  }
}

# Create Aws_route_table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "route_table"
  }
}

# Create Aws_route_table_association

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.route_table.id
}