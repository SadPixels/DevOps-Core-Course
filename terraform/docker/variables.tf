variable "image_name" {
  description = "Docker image name for the application."
  type        = string
  default     = "moscow-time-app:lab4-terraform"
}

variable "container_name" {
  description = "Docker container name."
  type        = string
  default     = "lab4-moscow-time-app"
}

variable "internal_port" {
  description = "Port exposed inside the container."
  type        = number
  default     = 8080
}

variable "external_port" {
  description = "Port exposed on the host."
  type        = number
  default     = 8080
}
