resource "docker_image" "moscow_time_app" {
  name         = var.image_name
  keep_locally = true

  build {
    context    = abspath("${path.module}/../../app_python")
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "moscow_time_app" {
  name  = var.container_name
  image = docker_image.moscow_time_app.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}
