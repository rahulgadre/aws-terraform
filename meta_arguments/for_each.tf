resource "aws_instance" "ec2_example" {
  for_each = {
    instance1 = "t2.micro"
    instance2 = "t2.medium"
  }
  ami           = "ami-1234567890123"
  instance_type = each.value
  tags = {

    Name = "Terraform ${each.key}"
  }

} 
