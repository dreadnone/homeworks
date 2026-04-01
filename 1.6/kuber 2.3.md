# Домашнее задание к занятию «Настройка приложений и управление доступом в Kubernetes»


------

## **Задание 1: Работа с ConfigMaps**
### **Задача**
Развернуть приложение (nginx + multitool), решить проблему конфигурации через ConfigMap и подключить веб-страницу.

[Ссылка на манифесты](https://github.com/dreadnone/homeworks/tree/main/1.6)

### **Шаги выполнения**
1. **Создать Deployment** с двумя контейнерами
   - `nginx`
   - `multitool`
3. **Подключить веб-страницу** через ConfigMap
4. **Проверить доступность**

### **Что сдать на проверку**
- Манифесты:
  - `deployment.yaml`
  - `configmap-web.yaml`
- Скриншот вывода `curl` или браузера
<img width="1162" height="324" alt="Снимок экрана от 2026-02-10 14-34-40" src="https://github.com/user-attachments/assets/e7e53c35-71e1-479f-a9db-ed7e5107be84" />

---
## **Задание 2: Настройка HTTPS с Secrets**  
### **Задача**  
Развернуть приложение с доступом по HTTPS, используя самоподписанный сертификат.

### **Шаги выполнения**  
1. **Сгенерировать SSL-сертификат**
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt -subj "/CN=myapp.example.com"
```
2. **Создать Secret**
3. **Настроить Ingress**
4. **Проверить HTTPS-доступ**

### **Что сдать на проверку**  
- Манифесты:
  - `secret-tls.yaml`
  - `ingress-tls.yaml`
- Скриншот вывода `curl -k`
<img width="970" height="69" alt="Снимок экрана от 2026-02-10 17-48-42" src="https://github.com/user-attachments/assets/d9fa47d3-b688-4305-a909-cce28af301f6" />
<img width="1164" height="586" alt="Снимок экрана от 2026-02-10 14-49-24" src="https://github.com/user-attachments/assets/7d8e7d2b-3afd-4d00-8e57-113146028135" />

---
## **Задание 3: Настройка RBAC**  
### **Задача**  
Создать пользователя с ограниченными правами (только просмотр логов и описания подов).

### **Шаги выполнения**  
1. **Включите RBAC в microk8s**
```bash
microk8s enable rbac
```
2. **Создать SSL-сертификат для пользователя**
```bash
openssl genrsa -out developer.key 2048
openssl req -new -key developer.key -out developer.csr -subj "/CN={ИМЯ ПОЛЬЗОВАТЕЛЯ}"
openssl x509 -req -in developer.csr -CA {CA серт вашего кластера} -CAkey {CA ключ вашего кластера} -CAcreateserial -out developer.crt -days 365
```
3. **Создать Role (только просмотр логов и описания подов) и RoleBinding**
4. **Проверить доступ**

### **Что сдать на проверку**  
- Манифесты:
  - `role-pod-reader.yaml`
  - `rolebinding-developer.yaml`
- Команды генерации сертификатов
- Скриншот проверки прав (`kubectl get pods --as=developer`)
 <img width="978" height="312" alt="Снимок экрана от 2026-02-10 17-49-20" src="https://github.com/user-attachments/assets/12b895f2-b520-4c62-830f-8592d21a0e1f" />
