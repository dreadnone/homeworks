# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

  ## [Main.tf](https://github.com/dreadnone/homeworks/blob/main/terraform/load-balancer/main.tf)

  ## [web](https://github.com/dreadnone/homeworks/blob/main/terraform/load-balancer/web-user-data.tftpl)


<img width="1685" height="552" alt="Снимок экрана (6)" src="https://github.com/user-attachments/assets/05a9a24c-8c3a-491f-95ab-8051f61b118a" />
<img width="813" height="127" alt="Снимок экрана (7)" src="https://github.com/user-attachments/assets/4ad26e24-4ae1-45cf-8271-3288d376737a" />
<img width="1233" height="768" alt="Снимок экрана (8)" src="https://github.com/user-attachments/assets/4e217f65-c13b-48c5-9212-b431be63b812" />

## Балансировщик в статусе ACTIVE
<img width="1389" height="700" alt="Снимок экрана (9)" src="https://github.com/user-attachments/assets/a11ad437-33fe-479e-8f02-b1739bc8bcba" />

<img width="877" height="750" alt="Снимок экрана (10)" src="https://github.com/user-attachments/assets/db1bacef-ab10-4179-955e-03e567e7d244" />

## Исходное состояние
<img width="1670" height="330" alt="Снимок экрана (11)" src="https://github.com/user-attachments/assets/e742abbb-282f-486d-a70e-9a2fc5aafd15" />

## Останавливаем одну ВМ
<img width="1660" height="210" alt="Снимок экрана (13)" src="https://github.com/user-attachments/assets/e8d0880b-cada-49ad-b0ed-cc6e22d1be9d" />

## Трафик идет через другую ВМ

<img width="646" height="694" alt="Снимок экрана (12)" src="https://github.com/user-attachments/assets/a07438b7-1352-41c2-8eb0-054a00292b9a" />

