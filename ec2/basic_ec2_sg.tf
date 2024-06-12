provider "aws" {
  profile = "default"
  region  =  "var.region"
}

resource "aws_instance" "example" {
  ami               = "ami-02f147dfb8be58a10"
  instance_type     = "t2.micro"
  security_groups   = ["rgg-secgrp"]
  availability_zone = "us-west-2c"
}
