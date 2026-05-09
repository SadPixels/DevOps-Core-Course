variable "cloud_id" {
  description = "Yandex Cloud ID."
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID."
  type        = string
}

variable "zone" {
  description = "Yandex Cloud availability zone."
  type        = string
  default     = "ru-central1-a"
}

variable "vm_name" {
  description = "VM instance name."
  type        = string
  default     = "lab4-terraform-vm"
}

variable "vm_user" {
  description = "Linux user for SSH access."
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key."
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "image_family" {
  description = "Yandex Cloud image family for the boot disk."
  type        = string
  default     = "ubuntu-2204-lts"
}
