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

# KMS ключ для шифрования бакета
resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = "bucket-encryption-key"
  description       = "Key for bucket encryption"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" # 1 год
}

# Бакет с шифрованием через KMS
resource "yandex_storage_bucket" "images" {
  bucket     = "dread-images-${formatdate("YYYY-MM-DD", timestamp())}"
  folder_id  = "b1go9gufkn4ii3hfibvu"
  acl        = "public-read"
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# Загружаем картинку в бакет
resource "yandex_storage_object" "image" {
  bucket = yandex_storage_bucket.images.bucket
  key    = "test.jpg"
  source = "C:/Users/DREAD/Pictures/test.jpg"
  acl    = "public-read"
}

# Вывод информации
output "bucket_url" {
  value = "https://${yandex_storage_bucket.images.bucket}.website.yandexcloud.net/${yandex_storage_object.image.key}"
}

output "kms_key_id" {
  value = yandex_kms_symmetric_key.bucket_key.id
}