terraform {
  required_version = ">=0.12"
}

# Defining the locals block with the rules for a new SG

locals {
  ingress_rules = [{
    port        = 22
    description = "Ingress rules for port 22"
    },
    {
      port        = 80
      description = "Ingree rules for port 80"
    },
    {
      port        = 443
      description = "Ingree rules for port 443"
  }]
}

# Creating a new SG with the rules defined in the dynamic block.

resource "aws_security_group" "main" {
  name   = "resource_with_dynamic_block"
  vpc_id = aws_vpc.terra_VPC.id
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# A new public subnet in a new VPC

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.terra_VPC.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Terra_public_subnet"
  }
  
}

# data "aws_route_table" "rt" {
#    subnet_id = aws_subnet.public.id
#   }

# output "route_table_id" {
#   value = data.aws_route_table.rt.id
# }

# Adding a default route to a new IGW

resource "aws_route" "pub_rt" {
  route_table_id            = aws_vpc.terra_VPC.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.pub_igw.id
}

# Creating a new internet gateway and attaching it to a new VPC ID

resource "aws_internet_gateway" "pub_igw" {
  vpc_id = aws_vpc.terra_VPC.id

  tags = {
    Name = "my terra pub igw"
  }
}


# A new private subnet in a new VPC
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.terra_VPC.id
  cidr_block        = "10.20.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Terra_private_subnet"
  }
}

# Creating a new VPC
resource "aws_vpc" "terra_VPC" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Terra_VPC"
  }
}

output "sg_id" {
  value = aws_security_group.main.id
  }

output "subnet_id" {
  value = aws_subnet.public.id
  
}
  
