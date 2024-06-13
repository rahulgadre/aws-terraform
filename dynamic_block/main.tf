locals {
  ingress_rules = [{
    port        = 1234
    description = "Ingress rules for port 1234"
    },
    {
      port        = 53
      description = "Ingree rules for port 53"
  }]
}

resource "aws_security_group" "main" {
  name   = "resource_with_dynamic_block"

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
}

resource "aws_instance" "terraform_ec2" {
  ami             = "ami-00f9f4069d04c0c6e"
  instance_type   = "t2.medium"
  vpc_security_group_ids = [aws_security_group.main.id]
  tags = {
    Name = "My Dyna EC2"
  }
}
