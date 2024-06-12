provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_s3_bucket" "terraform-bucket" {
  bucket = "rgg-terraform-bucket"
  acl    = "private"
}
