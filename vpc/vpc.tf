#vpc.tf
#Deploying a VPC environment in AWS using Terraform

provider "aws" {
  profile = "default"
  region  =  var.region
}

# Create the VPC

resource "aws_vpc" "rgg-vpc" {
  cidr_block        = var.vpcCIDRBlock
  instance_tenancy  = var.instanceTenancy
  enable_dns_hostnames  = var.dnsHostname
  enable_dns_support    = var.dnsSupport

  tags = {
        Name = "rgg-vpc"
  }
}
# Create the public subnet
resource "aws_subnet" "public" {
    vpc_id  = aws_vpc.rgg-vpc.id
    cidr_block  = var.pubCIDRblock
    map_public_ip_on_launch = var.mapPublicIP
    availability_zone   = var.pubaz

    tags = {
        Name = "rgg-public-subnet"
    }
}

# Create the private subnet
resource "aws_subnet" "private" {
    vpc_id  = aws_vpc.rgg-vpc.id
    cidr_block  = var.priCIDRblock
    map_public_ip_on_launch = var.mapPrivateIP
    availability_zone   = var.priaz

    tags = {
        Name = "rgg-private-subnet"
    }
  
}

# Create the Internet Gateway
resource "aws_internet_gateway" "rgg_VPC_GW" {
 vpc_id = aws_vpc.rgg-vpc.id
 tags = {
        Name = "My VPC Internet Gateway"
}
} 

# Create the Route Table
resource "aws_route_table" "rgg-vpc-rt" {
 vpc_id = aws_vpc.rgg-vpc.id
 tags = {
        Name = "rgg-vpc-rt"
 }
}

#Associating public subnet to the custom vpc route table
resource "aws_route_table_association" "rtassociation" {
  route_table_id    = aws_route_table.rgg-vpc-rt.id
  subnet_id =  aws_subnet.public.id
}



# Create Security Group for public subnet

resource  "aws_security_group" "rgg-vpc-sg" {
  vpc_id    =   aws_vpc.rgg-vpc.id
  name         = "rgg-vpc-sg"
  description  = "SG deployed using Terraform"

# Allow ping to the public VM

 ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  } 

# Allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group for private subnet

resource  "aws_security_group" "rgg-priv-sg" {
  vpc_id    =   aws_vpc.rgg-vpc.id
  name         = "rgg-priv-sg"
  description  = "Private SG deployed using Terraform"

# Allow ping to the public VM

 ingress {
    cidr_blocks = var.pringressCIDRblock  
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  } 

# Allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the Internet Access
resource "aws_route" "rgg-vpc-internet_access" {
  route_table_id         = aws_route_table.rgg-vpc-rt.id
  destination_cidr_block = var.destCIDRblock
  gateway_id             = aws_internet_gateway.rgg_VPC_GW.id
}

#Deploying a public EC2 instance in VPC

resource "aws_instance" "pubvm" {
  ami               = "ami-0e34e7b9ca0ace12d"
  instance_type     = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids   = ["sg-0c7425e0d987d6bdf"]
  availability_zone = var.pubaz
  tags = {
      Name = "My Public VM"
  }
}

#Deploying a private EC2 instance in VPC

resource "aws_instance" "privm" {
  ami               = "ami-0e34e7b9ca0ace12d"
  instance_type     = "t2.micro"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids   = ["sg-0c7425e0d987d6bdf"]
  associate_public_ip_address = var.mapPrivateIP
  availability_zone = var.priaz
  tags = {
      Name = "My Private VM"
  }
}
