# Create a random password and store it in a local file using the local_file resource.

resource "random_password" "password" {
  length           = 6
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "local_file" "my_pwd_file" {
  filename        = "pwd.txt"
  content         = random_password.password.result
  file_permission = "600"
}
