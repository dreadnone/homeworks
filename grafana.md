# Домашнее задание к занятию 14 «Средство визуализации Grafana»

## Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
использовали в процессе решения задания.

**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.
<img width="1874" height="962" alt="Снимок экрана от 2026-03-04 12-13-38" src="https://github.com/user-attachments/assets/bb9be582-5ad6-49a8-9d1a-b3c92edd3d50" />

## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
- CPULA 1/5/15;
- количество свободной оперативной памяти;
- количество места на файловой системе.

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.
<img width="1538" height="821" alt="Снимок экрана от 2026-03-04 14-43-10" src="https://github.com/user-attachments/assets/3c94c7d1-3db2-4e4e-86ae-92a21dbcc752" />
<img width="1538" height="821" alt="Снимок экрана от 2026-03-04 14-43-22" src="https://github.com/user-attachments/assets/90a38c98-6bc3-4a4f-848c-87f8158418d8" />
<img width="1538" height="821" alt="Снимок экрана от 2026-03-04 14-43-44" src="https://github.com/user-attachments/assets/f33005a3-44e3-46dc-a7c1-8a2521822d92" />
<img width="1538" height="821" alt="Снимок экрана от 2026-03-04 14-43-57" src="https://github.com/user-attachments/assets/6f8c6ec2-c749-4a79-8baf-06823b1597f4" />
<img width="1538" height="821" alt="Снимок экрана от 2026-03-04 14-44-42" src="https://github.com/user-attachments/assets/27ebd2d1-885f-4334-b05e-4f3ee9d47a32" />

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

<img width="1874" height="962" alt="Снимок экрана от 2026-03-04 12-36-55" src="https://github.com/user-attachments/assets/32a65117-f9ff-4e15-8944-dc8656adfa60" />

## Сделал тест алертинга на почту 
<img width="1538" height="821" alt="Снимок экрана от 2026-03-04 14-41-35" src="https://github.com/user-attachments/assets/7a016e52-39a0-49b7-987b-7687585de366" />

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
2. В качестве решения задания приведите листинг этого файла.

[json Dashboard](https://github.com/dreadnone/homeworks/blob/main/firstdashboard.json)
---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
