provider "docker" {
  host = "tcp://localhost:8080"
}

# Start a container
resource "docker_container" "nginx" {
  name  = "mycont"
  image = "docker_image.nginx"
}
