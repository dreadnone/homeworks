terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.130"
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

# Создаём бакет для картинки
resource "yandex_storage_bucket" "images" {
  bucket     = "dread-images-${formatdate("YYYY-MM-DD", timestamp())}"
  folder_id  = "b1go9gufkn4ii3hfibvu"
  acl        = "public-read"
  
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
# Загружаем картинку в бакет
resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.images.bucket
  key    = "test.jpg"
  source = "C:/Users/DREAD/Pictures/test.jpg"
  acl    = "public-read"
}

# Создаём сеть и подсети
resource "yandex_vpc_network" "main" {
  name = "load-balancer-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  network_id     = yandex_vpc_network.main.id
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Группа безопасности для ВМ
resource "yandex_vpc_security_group" "web" {
  name        = "web-sg"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTP"
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "SSH"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

# Создаём целевую группу для балансировщика
resource "yandex_lb_target_group" "web_group" {
  name      = "web-target-group"
  folder_id = "b1go9gufkn4ii3hfibvu"
}

# Шаблон для Instance Group
resource "yandex_compute_instance_group" "web_servers" {
  name               = "web-servers"
  folder_id          = "b1go9gufkn4ii3hfibvu"
  service_account_id = "aje3llnhcev4d83e46he"

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  instance_template {
    platform_id = "standard-v2"
    
    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.main.id
      subnet_ids         = [yandex_vpc_subnet.public.id]
      nat                = true
      security_group_ids = [yandex_vpc_security_group.web.id]
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.public_key_path)}"
      user-data = templatefile("${path.module}/web-user-data.tftpl", {
        image_url = "https://${yandex_storage_bucket.images.bucket}.website.yandexcloud.net/${yandex_storage_object.image.key}"
      })
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }

  health_check {
    interval = 30
    timeout  = 10
    tcp_options {
      port = 80
    }
  }

  load_balancer {
    # target_group_id будет создан автоматически
  }
}

# Network Load Balancer
resource "yandex_lb_network_load_balancer" "web_lb" {
  name = "web-load-balancer"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web_group.id
    healthcheck {
      name = "http"
      interval = 2
      timeout = 1
      unhealthy_threshold = 2
      healthy_threshold = 2
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

# Вывод информации
output "bucket_url" {
  value = "https://${yandex_storage_bucket.images.bucket}.website.yandexcloud.net/${yandex_storage_object.image.key}"
}

output "load_balancer_ip" {
  value = flatten(yandex_lb_network_load_balancer.web_lb.listener[*].external_address_spec)[0].address
}