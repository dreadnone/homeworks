terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.195.0"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = "b1gf3uq2e7org19bmnfj"
  folder_id = "b1go9gufkn4ii3hfibvu"
  zone      = "ru-central1-a"
}

variable "yc_token" {
  sensitive = true
}

variable "public_key_path" {
  default = "C:/Users/DREAD/.ssh/id_rsa.pub"
}


resource "yandex_vpc_network" "main" {
  name = "vpc-main"
}


resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  network_id     = yandex_vpc_network.main.id
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
}


resource "yandex_vpc_route_table" "private_route" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.main.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}


resource "yandex_vpc_subnet" "private_routed" {
  name           = "private-subnet-routed"
  network_id     = yandex_vpc_network.main.id
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private_route.id
}


resource "yandex_vpc_security_group" "ssh" {
  name        = "ssh-sg"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "SSH"
  }

  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Ping"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
    description    = "All outbound"
  }
}


resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = "192.168.10.254"
    nat                = true
    security_group_ids = [yandex_vpc_security_group.ssh.id]
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_routed.id
    ip_address         = "192.168.20.254"
    security_group_ids = [yandex_vpc_security_group.ssh.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}


resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd807i1otb8jnlok99in"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.ssh.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    user-data = <<-EOF
      #cloud-config
      runcmd:
        - apt update
        - apt install -y net-tools
        - ip route add 192.168.20.0/24 via 192.168.10.254 || true
        - echo "Gateway configured"
    EOF
  }
}


resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd807i1otb8jnlok99in"
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_routed.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.ssh.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    user-data = <<-EOF
      #cloud-config
      write_files:
        - path: /etc/netplan/50-cloud-init.yaml
          content: |
            network:
                ethernets:
                    eth0:
                        dhcp4: true
                        dhcp4-overrides:
                            use-routes: false
                        routes:
                          - to: default
                            via: 192.168.20.254
                        nameservers:
                          addresses: [8.8.8.8]
                version: 2
      runcmd:
        - apt update
        - apt install -y net-tools
        - netplan apply
        - ip neigh del 192.168.20.254 dev eth0 || true
        - ip neigh add 192.168.20.254 lladdr d0:1d:11:61:8e:04 dev eth0 nud permanent
        - echo "nameserver 8.8.8.8" >> /etc/resolv.conf
        - echo "Network configured"
    EOF
  }
}


output "nat_ip" {
  value = yandex_compute_instance.nat.network_interface.0.nat_ip_address
}

output "public_ip" {
  value = yandex_compute_instance.public_vm.network_interface.0.nat_ip_address
}

output "private_ip" {
  value = yandex_compute_instance.private_vm.network_interface.0.ip_address
}
