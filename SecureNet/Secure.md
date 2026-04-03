
# Домашнее задание к занятию «Безопасность в облачных провайдерах»  

Используя конфигурации, выполненные в рамках предыдущих домашних заданий, нужно добавить возможность шифрования бакета.

---
## Задание 1. Yandex Cloud   

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

 - создать ключ в KMS;
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.
2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:

 - создать сертификат;
 - создать статическую страницу в Object Storage и применить сертификат HTTPS;
 - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).

Полезные документы:

- [Настройка HTTPS статичного сайта](https://cloud.yandex.ru/docs/storage/operations/hosting/certificate).
- [Object Storage bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket).
- [KMS key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key).

 - ## [Main.tf](https://github.com/dreadnone/homeworks/blob/main/SecureNet/main.tf)

 <img width="419" height="189" alt="Снимок экрана (14)" src="https://github.com/user-attachments/assets/d398eb9c-a1cc-49a0-b285-fdba40ccc6dc" />

<img width="627" height="374" alt="Снимок экрана (15)" src="https://github.com/user-attachments/assets/9a35149d-7931-4df5-b476-a2023b780d83" />

<img width="1441" height="665" alt="Снимок экрана (16)" src="https://github.com/user-attachments/assets/230b4edd-47fd-4685-b87a-f5fb3dbcaa58" />

