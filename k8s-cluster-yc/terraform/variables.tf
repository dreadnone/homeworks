variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "yc_zone" {
  description = "Yandex Cloud Zone"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key" {
  description = "SSH public key for instances"
  type        = string
}

variable "instance_resources" {
  description = "Instance resources"
  type = object({
    master = object({
      cores  = number
      memory = number
    })
    worker = object({
      cores  = number
      memory = number
    })
  })
  default = {
    master = {
      cores  = 4
      memory = 8
    }
    worker = {
      cores  = 4
      memory = 8
    }
  }
}