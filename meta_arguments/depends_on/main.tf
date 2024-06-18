resource "aws_s3_bucket" "bucket" {
  bucket     = var.bucketname
  depends_on = [aws_instance.terraform_ec2]
}

resource "aws_instance" "terraform_ec2" {
  ami                    = var.myami
  instance_type          = var.instance_type
  vpc_security_group_ids = ["sg-xxxxxxxxxxxxxxxx"]
  tags = {
    Name = var.ec2name
  }
}
