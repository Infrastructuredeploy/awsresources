# Configure the AWS vpc
resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}

# Configure the AWS Internet gateway
resource "aws_internet_gateway" "myinternet" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myinternet"
  }
}

# Define subnet configurations
locals {
  subnets = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name              = "Subnet01"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      name              = "Subnet02"
    },
    {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1c"
      name              = "Subnet03"
    },
    {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1d"
      name              = "Subnet04"
    },
  ]
}


# Configure the AWS Public Subnet
resource "aws_subnet" "mysubnet" {
  count                   = length(local.subnets)
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = local.subnets[count.index].cidr_block
  availability_zone       = local.subnets[count.index].availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = local.subnets[count.index].name
  }
}

# Configure the AWS Route Table

resource "aws_route_table" "myroute-table" {
  vpc_id = aws_vpc.myvpc.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.myinternet.id
  }

  tags = {
    Name = "myroute-table"
  }
}

# Configure the Aws_route_table_association

resource "aws_route_table_association" "route_table_association" {
  count          = length(aws_subnet.mysubnet)
  subnet_id      = aws_subnet.mysubnet[count.index].id
  route_table_id = aws_route_table.myroute-table.id
}
