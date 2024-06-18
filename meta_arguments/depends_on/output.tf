output "ec2" {
  value = {
    pub_ip = aws_instance.terraform_ec2.public_ip
    priv_ip = aws_instance.terraform_ec2.private_ip
}
}
