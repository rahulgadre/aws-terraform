provider "aws" {
  shared_config_files      = ["/home/$USER/.aws/conf"]
  shared_credentials_files = ["/home/$USER/.aws/creds"]
}

resource "aws_instance" "terraform_ec2" {
  ami                     = "ami-00f9f4069d04c0c6e"
  instance_type           = "t2.medium"
  tags = {
    Name = "My Terra Instance"
  }
}

data "aws_instance" "terraform_ec2" {
   instance_id = aws_instance.terraform_ec2.id

}

output "out" {
  value = data.aws_instance.terraform_ec2.instance_id 

}
