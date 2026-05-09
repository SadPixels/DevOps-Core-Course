output "image_name" {
  description = "Built Docker image name."
  value       = docker_image.moscow_time_app.name
}

output "container_name" {
  description = "Created Docker container name."
  value       = docker_container.moscow_time_app.name
}

output "container_id" {
  description = "Created Docker container ID."
  value       = docker_container.moscow_time_app.id
}

output "container_url" {
  description = "Application URL on the local host."
  value       = "http://localhost:${var.external_port}"
}
