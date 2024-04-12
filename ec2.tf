# Define instance configurations
locals {
  instances = [
    {
      name          = "jenkins-sever"
      ami           = "ami-0fe630eb857a6ec83" # Specify your desired AMI ID
      instance_type = "t2.medium"
    },
    {
      name          = "marvin-sever"
      ami           = "ami-0fe630eb857a6ec83" # Specify your desired AMI ID
      instance_type = "t2.medium"
    },
    {
      name          = "sonarqube-sever"
      ami           = "ami-0fe630eb857a6ec83" # Specify your desired AMI ID
      instance_type = "t2.medium"
    },
    {
      name          = "nexus-sever"
      ami           = "ami-0fe630eb857a6ec83" # Specify your desired AMI ID
      instance_type = "t2.medium"
    },
  ]
}

# Creating Keypair for aws Ec2
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}


# Creating Security Group for EC2
resource "aws_security_group" "demosg" {
  name        = "Demo Security Group"
  description = "Demo Module"
  vpc_id      = aws_vpc.myvpc.id
  # Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating Aws Ec2 instance
resource "aws_instance" "myinstance" {
  count         = length(local.subnets)
  ami           = local.instances[count.index].ami
  instance_type = local.instances[count.index].instance_type
  subnet_id     = element(aws_subnet.mysubnet[*].id, count.index)
  key_name      = "TF_key"

  # Attach the security group to the instance
  vpc_security_group_ids = [aws_security_group.demosg.id]


  tags = {
    Name = local.instances[count.index].name
  }
}
