output "vm_name" {
  description = "Created VM name."
  value       = yandex_compute_instance.lab4.name
}

output "public_ip" {
  description = "VM public IP address."
  value       = yandex_compute_instance.lab4.network_interface[0].nat_ip_address
}

output "internal_ip" {
  description = "VM internal IP address."
  value       = yandex_compute_instance.lab4.network_interface[0].ip_address
}
