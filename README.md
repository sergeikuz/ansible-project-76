### Hexlet tests and linter status:
[![Actions Status](https://github.com/sergeikuz/ansible-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/sergeikuz/ansible-project-76/actions)

---

# Ansible Project 76

## Статус проекта

Инфраструктура Yandex Cloud создана и настроена. Балансировщик работает и распределяет трафик между двумя ВМ.

## Инфраструктура (Yandex Cloud)

### Виртуальные машины

| Имя | Внешний IP | Внутренний IP | Зона | Статус |
|-----|------------|---------------|------|--------|
| compute-vm-2-1-15-ssd-1777883033560 | 111.88.147.207 | 10.129.0.3 | ru-central1-b | RUNNING |
| compute-vm-2-1-12-ssd-1777883153308 | 111.88.145.247 | 10.129.0.8 | ru-central1-b | RUNNING |

- **OS:** Ubuntu 24.04 LTS
- **Платформа:** standard-v4a (2 vCPU, 1 GB RAM)
- **Диск:** SSD

### Сеть

- **VPC:** default (enp9ba351826kbqci7i0)
- **Подсети:** default-ru-central1-a (10.128.0.0/24), default-ru-central1-b (10.129.0.0/24), default-ru-central1-d (10.130.0.0/24), default-ru-central1-e (10.131.0.0/24)

### Application Load Balancer (L7)

- **Публичный IP:** 111.88.146.158
- **Порт:** 80 (HTTP)
- **Статус:** работает, отвечает 200 OK

Компоненты ALB:
- **Целевая группа:** test-target-group (обе ВМ)
- **Группа бэкендов:** test-backend-group (порт 8080, HTTP health check)
- **HTTP-роутер:** test-http-router (маршрут `/` → backend group)
- **L7-балансировщик:** test-load-balancer (обработчик на порту 80)

## Подключение к ВМ

### Через SSH-конфиг (рекомендуется)

```bash
ssh yc-vm-1   # первая ВМ (111.88.147.207)
ssh yc-vm-2   # вторая ВМ (111.88.145.247)
```

### Через yc CLI

```bash
yc compute ssh --name compute-vm-2-1-15-ssd-1777883033560 --login mrkuzy9999 -i ~/.ssh/id_rsa
```

### Напрямую через SSH

```bash
ssh -i ~/.ssh/id_rsa mrkuzy9999@111.88.147.207
ssh -i ~/.ssh/id_rsa mrkuzy9999@111.88.145.247
```

## Что сделано

- [x] Созданы 2 виртуальные машины в Yandex Compute Cloud
- [x] Настроена VPC сеть с подсетями в 4 зонах доступности
- [x] Настроен SSH доступ через OS Login
- [x] Создан и настроен Application Load Balancer (L7)
- [x] Балансировщик распределяет трафик между двумя ВМ (порт 8080)
- [x] Настроены health checks для бэкендов
- [x] Протестирована работа балансировщика (curl → 200 OK)

## Следующие шаги

- [ ] Установка Docker на обе ВМ (Ansible playbook)
- [ ] Развёртывание приложения в Docker-контейнерах
- [ ] Создание кластера PostgreSQL (Managed Service for PostgreSQL)
- [ ] Настройка групп безопасности (alb-sg, vm-sg)
- [ ] Настройка подключения приложения к БД
- [ ] Автоматизация инфраструктуры через Ansible

## Тестирование балансировщика

```bash
curl --verbose 111.88.146.158:80
# HTTP/1.1 200 OK
# server: ycalb
```
