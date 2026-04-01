# Домашнее задание к занятию «Система мониторинга Zabbix»

### Задание 1

Установите Zabbix Server с веб-интерфейсом.
входим в SUDO
 sudo -i
Устанавливаем репозиторий Zabbix

wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu24.04_all.deb

dpkg -i zabbix-release_latest_7.2+ubuntu24.04_all.deb

apt update

Установливаем Zabbix сервер, веб-интерфейс и агент

apt install zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent

Создаем базу данных

Выполняем следующие комманды на хосте, где будет распологаться база данных.

sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix
На хосте Zabbix сервера импортируйте начальную схему и данные. Вам будет предложено ввести недавно созданный пароль.

zcat /usr/share/zabbix/sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
Настройка базы данных для Zabbix сервера
Отредактируем файл /etc/zabbix/zabbix_server.conf

DBPassword=password
Запускаем процессы Zabbix сервера и агента
Запускаем процессы Zabbix сервера и агента и настройте их запуск при загрузке ОС.

 systemctl restart zabbix-server zabbix-agent apache2
 systemctl enable zabbix-server zabbix-agent apache2
![dashboard1](https://github.com/user-attachments/assets/596cfa85-7c19-43aa-9522-39df85458971)
---

### Задание 2
В качестве одного из хостов использовалась машина с Zabbix-сервером, в качестве второго — чистая виртуальная машина.

Установка заббикс агента
sudo apt устанавливает zabbix-агент

Рестарт и добавление в автозагрузку Заббикс агента
systemctl перезапустит zabbix-агент

systemctl включает zabbix-агент

Настраиваем параметры подключения Zabbix-агента к серверу (прописываем адреса хостов)

sed -i 's/Server=127.0.0.1/Server=192.168.0.101/g' /etc/zabbix/zabbix_agentd.conf

sed -i 's/Server=127.0.0.1/Server=192.168.0.102/g' /etc/zabbix/zabbix_agentd.conf
     
Вторая вм на dashboard
![dashboard2](https://github.com/user-attachments/assets/c21cab9a-b98d-4ced-be4f-4c6c57548132)

Раздел configuration
![hosts](https://github.com/user-attachments/assets/7d9f3eb3-f9d8-47f3-bb21-b2510ae7aa0a)

Раздел Monitoring > Latest data для обоих хостов, где видны поступающие от агентов данные.
![testhost](https://github.com/user-attachments/assets/617327a9-c528-469a-aaf7-1c54012100a7)

![myhost](https://github.com/user-attachments/assets/7090cfe3-576a-4f4c-9a37-1898d6aa3787)

лог агента на котором видно что он работает с сервером
![Снимок экрана (1)](https://github.com/user-attachments/assets/cf34cf32-5d1a-407a-8799-c0fae2c9f8a7)
