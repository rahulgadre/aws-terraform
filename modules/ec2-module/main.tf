terraform {
  required_version = ">=0.12"
}

module "vpc-module" {

  source = "../VPC-Module"

}

# Launching an EC2 instance in a new VPC and adding userdata to install a webserver
resource "aws_instance" "terraform_ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.vpc-module.sg_id]
  subnet_id              = module.vpc-module.subnet_id
  user_data             = <<-EOF
                          #!/bin/bash
                          sudo yum update -y
                          sudo yum install -y httpd
                          sudo systemctl start httpd
                          sudo systemctl enable httpd
                          sudo echo "This is RGG's instance that is successfully running the Apache Webserver!" > /var/www/html/index.html
                          EOF 
  user_data_replace_on_change = true
  tags = {
    Name = "My Terra EC2"
  }
}
