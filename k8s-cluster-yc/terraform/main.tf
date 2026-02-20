terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.97.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

# Data source для получения последнего образа Ubuntu 20.04
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

# Создание сети
resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

# Создание подсети
resource "yandex_vpc_subnet" "k8s-subnet" {
  name           = "k8s-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

# Создание security groups
resource "yandex_vpc_security_group" "k8s-sg" {
  name        = "k8s-security-group"
  description = "Security group for Kubernetes cluster"
  network_id  = yandex_vpc_network.k8s-network.id

  # Входящий трафик для SSH
  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  # Входящий трафик для Kubernetes API
  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6443
  }

  # Входящий трафик для etcd
  ingress {
    protocol       = "TCP"
    description    = "etcd"
    v4_cidr_blocks = ["10.0.0.0/8"]
    port           = 2379-2380
  }

  # Входящий трафик для kubelet
  ingress {
    protocol       = "TCP"
    description    = "kubelet"
    v4_cidr_blocks = ["10.0.0.0/8"]
    port           = 10250
  }

  # Входящий трафик для NodePort services
  ingress {
    protocol       = "TCP"
    description    = "NodePort services"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }

  # Весь исходящий трафик разрешен
  egress {
    protocol       = "ANY"
    description    = "All outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Мастер-нода
resource "yandex_compute_instance" "master" {
  name        = "k8s-master"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores         = 4
    memory        = 8
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 40
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.k8s-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s-sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

# Рабочие ноды
resource "yandex_compute_instance" "worker" {
  count       = 4
  name        = "k8s-worker-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores         = 4
    memory        = 8
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 40
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.k8s-subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s-sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

# Инвентарь для Ansible
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    master_ips = [yandex_compute_instance.master.network_interface.0.nat_ip_address]
    worker_ips = yandex_compute_instance.worker[*].network_interface.0.nat_ip_address
  })
  filename = "../ansible/inventory/hosts.ini"
}

# Вывод IP-адресов
output "master_public_ip" {
  value = yandex_compute_instance.master.network_interface.0.nat_ip_address
}

output "worker_public_ips" {
  value = yandex_compute_instance.worker[*].network_interface.0.nat_ip_address
}

output "connect_to_master" {
  value = "ssh ubuntu@${yandex_compute_instance.master.network_interface.0.nat_ip_address}"
}