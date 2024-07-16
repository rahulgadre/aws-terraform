provider "aws" {
  shared_config_files      = ["<location to conf>"]
  shared_credentials_files = ["<location to creds>"]
}


module "ec2-module" {
  source = ".//EC2-Module"
}
