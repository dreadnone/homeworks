Домашнее задание к занятию «Система мониторинга Zabbix»
Задание 1
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




