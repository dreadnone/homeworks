# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

------
### Для выполнения решил запустить в Yandex cloud 5 ВМ с помощью [Terraform(манифесты)](https://github.com/dreadnone/homeworks/tree/main/k8s-cluster-yc)

<img width="1813" height="447" alt="Снимок экрана от 2026-02-20 20-02-03" src="https://github.com/user-attachments/assets/13dd6307-327a-4750-a378-ae62d55dcc4c" />



<img width="1244" height="529" alt="Снимок экрана от 2026-02-20 20-01-09" src="https://github.com/user-attachments/assets/8754aaa3-a003-49f0-9bdb-c913d4695cee" />

**Проверил одну из нод извне**
<img width="976" height="413" alt="Снимок экрана от 2026-02-20 20-01-28" src="https://github.com/user-attachments/assets/4d7a389c-ff61-4014-8fac-af59287e1f78" />

