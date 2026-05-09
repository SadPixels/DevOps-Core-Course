data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_vpc_network" "lab4" {
  name = "lab4-network"
}

resource "yandex_vpc_subnet" "lab4" {
  name           = "lab4-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.lab4.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

resource "yandex_compute_instance" "lab4" {
  name        = var.vm_name
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lab4.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }
}
