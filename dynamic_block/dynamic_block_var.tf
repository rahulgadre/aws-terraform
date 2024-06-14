resource "aws_security_group" "terra_sg" {
  name        = "My Terra SG"
  description = "This SG is managed by Terraform"

  dynamic "ingress" {
    for_each = var.ingress_ports
    // for_each = var.ingress_ports
    iterator = ports
    content {
      from_port   = ports.value // ingress.value
      to_port     = ports.value // ingress.value
      protocol    = "tcp"
      cidr_blocks = ["1.2.3.4/32"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
