### Hexlet tests and linter status:
[![Actions Status](https://github.com/sergeikuz/ansible-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/sergeikuz/ansible-project-76/actions)

---

# Ansible Project 76

## Ссылки

- **Приложение:** http://sergei3333.ru
- **Репозиторий:** https://github.com/sergeikuz/ansible-project-76
- **CI/CD:** https://github.com/sergeikuz/ansible-project-76/actions

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
- **Порты:** 80 (HTTP), 443 (HTTPS — сертификат Let's Encrypt в процессе валидации)
- **Статус:** работает, отвечает 200 OK

Компоненты ALB:
- **Целевая группа:** test-target-group (обе ВМ)
- **Группа бэкендов:** test-backend-group (порт 8080, HTTP health check)
- **HTTP-роутер:** test-http-router (маршрут `/` → backend group)
- **L7-балансировщик:** test-load-balancer (обработчик на порту 80)

### Группы безопасности

| Имя | ID | Назначение | Правила |
|-----|----|------------|---------|
| db-sg | enpi4tpapao3g0a42tca | PostgreSQL кластер | Входящий 5432, 6432 только из 10.129.0.0/24 и 10.130.0.0/24 |

### Кластер PostgreSQL

| Параметр | Значение |
|----------|----------|
| Имя | postgresql710 |
| Версия | PostgreSQL 16 |
| Среда | PRODUCTION |
| Пресет | c3-c2-m4 (2 vCPU, 4 GB RAM) |
| Диск | network-ssd, 10 GB |
| БД | db1 (владелец: user1) |
| Статус | RUNNING |

**Хосты:**

| # | Зона | Подсеть |
|---|------|---------|
| 1 | ru-central1-b | default-ru-central1-b |
| 2 | ru-central1-d | default-ru-central1-d |

**Безопасность:**
- Группа безопасности: `db-sg` (enpi4tpapao3g0a42tca)
- Доступ к порту 5432 разрешён только из подсети ВМ (`10.129.0.0/24`)
- Репликация между хостами через `10.130.0.0/24`
- Защита от удаления: включена
- Бэкапы: ежедневно 22:00-23:00 UTC, хранение 7 дней

### DNS и домен

| Параметр | Значение |
|----------|----------|
| Домен | sergei3333.ru |
| Регистратор | reg.ru |
| DNS-зона | Yandex Cloud DNS (dnsd7n740bd9ptvh1n4v) |
| NS-серверы | ns1.yandexcloud.net, ns2.yandexcloud.net |
| A-запись | sergei3333.ru → 111.88.146.158 |

**Делегирование:** домен делегирован на Yandex Cloud DNS через reg.ru

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
- [x] Создан кластер PostgreSQL 16 (2 хоста, ru-central1-b + ru-central1-d)
- [x] Создана группа безопасности `db-sg` (доступ к БД только с ВМ, порты 5432 + 6432)
- [x] Зарегистрирован домен sergei3333.ru (reg.ru)
- [x] Создана DNS-зона в Yandex Cloud DNS
- [x] Добавлена A-запись (IP балансировщика)
- [x] Домен делегирован на Yandex Cloud NS-серверы
- [x] Установлен Docker на обе ВМ (Ansible playbook)
- [x] Развёрнут Redmine в Docker-контейнерах на обеих ВМ
- [x] Настроено подключение Redmine к PostgreSQL кластеру
- [x] Создан Let's Encrypt сертификат для HTTPS (в процессе валидации)

## Следующие шаги

- [ ] Добавить HTTPS обработчик в ALB (после валидации сертификата)
- [ ] Настроить редирект HTTP → HTTPS в HTTP-роутере
- [ ] Создание групп безопасности для ALB и ВМ (alb-sg, vm-sg)

## Тестирование

### Приложение (Redmine)
```bash
# Напрямую на серверах
curl http://111.88.147.207:8080  # server1
curl http://111.88.145.247:8080  # server2

# Через балансировщик
curl http://111.88.146.158:80

# По домену
curl http://sergei3333.ru
```

### Балансировщик
```bash
curl --verbose 111.88.146.158:80
# HTTP/1.1 200 OK
# server: ycalb
```

### Домен
```bash
dig sergei3333.ru +short
# 111.88.146.158
```

## Деплой

### Требования

- Ansible 2.14+
- Python 3.8+
- SSH-ключ `~/.ssh/id_rsa` с доступом к серверам

### Установка зависимостей

```bash
make prepare-packages
```

Или вручную:
```bash
ansible-galaxy role install -r requirements.yml
ansible-galaxy collection install -r requirements.yml
```

### Подготовка серверов

```bash
make prepare-servers
```

Или вручную:
```bash
ansible-playbook playbook.yml -i inventory.ini
```

### Проверка подключения

```bash
ansible all -i inventory.ini -m ping
```

### Деплой приложения (Redmine)

```bash
make deploy
```

Или вручную:
```bash
ansible-playbook deploy.yml -i inventory.ini --vault-password-file ~/.vault_pass
```

### Структура проекта

```
├── playbook.yml              # Плейбук подготовки серверов (Docker, pip)
├── deploy.yml                # Плейбук деплоя Redmine
├── inventory.ini             # Инвентаризация хостов
├── requirements.yml          # Роли и коллекции Ansible Galaxy
├── Makefile                  # Команды для деплоя
├── templates/
│   └── redmine.env.j2        # Шаблон .env для Redmine
├── group_vars/
│   └── webservers/
│       ├── vars.yml          # Переменные группы webservers
│       └── vault.yml         # Зашифрованные переменные (db_password)
│   └── webservers.yml        # Переменные для группы webservers
└── README.md                 # Документация
```
