# AGENTS.md

## Project

Hexlet Ansible project — deploys Docker + Redmine to two Yandex Cloud VMs via SSH, behind an Application Load Balancer.

## Critical constraints

- **`playbook.yml` must use `hosts: all`** — required by Hexlet auto-checker
- **`requirements.yml` must declare all Galaxy roles and collections** used in the playbook
- **Inventory must contain a `webservers` group** — required by auto-checker

## Commands

```bash
make prepare-packages   # Install Galaxy roles + collections (run first)
make prepare-servers    # Run server setup playbook (Docker, pip)
make deploy             # Deploy Redmine application
ansible all -i inventory.ini -m ping  # Quick connectivity check
```

Order: `prepare-packages` → `prepare-servers` → `deploy`

## SSH details

- User: `mrkuzy9999`
- Key: `~/.ssh/id_rsa`
- `StrictHostKeyChecking=no` set in `[webservers:vars]`
- VMs are in Yandex Cloud; public IPs may change on stop/restart — update `inventory.ini` if they do

## Playbook gotchas

- **`become: true` is required** — apt/docker tasks need root
- **`pre_tasks: apt update_cache` is required** — without it, `docker-ce` package is not found on fresh cache (seen on Ubuntu 24.04)
- **`db_port` must be a string** (`"6432"` not `6432`) — Ansible env vars reject integers
- **`deploy.yml` uses `env:` dict** not `env_file` — Docker module can't read root-owned files

## Vault

- Password file: `~/.vault_pass`
- Encrypted vars: `group_vars/all/vault.yml` (contains `db_password`)
- Deploy command requires `--vault-password-file ~/.vault_pass`

## File structure

| File | Purpose |
|---|---|
| `playbook.yml` | Server setup playbook (hosts: all) — installs pip, Docker |
| `deploy.yml` | App deployment playbook — deploys Redmine container |
| `inventory.ini` | Host definitions (webservers group) |
| `requirements.yml` | Galaxy roles + collections |
| `templates/redmine.env.j2` | Template for Redmine .env file |
| `group_vars/all/vars.yml` | Shared variables (db_host, db_port, redmine_port) |
| `group_vars/all/vault.yml` | Encrypted variables (db_password) |
| `group_vars/webservers.yml` | Webserver-specific variables |

## Infrastructure

- **VMs:** 2x Ubuntu 24.04 in ru-central1-b
- **ALB:** L7 load balancer, port 80 → backend port 8080
- **DB:** PostgreSQL 16 cluster (2 hosts), port 6432 (pgbouncer)
- **Security group `db-sg`:** allows 5432 + 6432 only from VM subnets
- **Domain:** sergei3333.ru (reg.ru → Yandex Cloud DNS)
- **Certificate:** Let's Encrypt (fpqt1n5m1s8plo6jhvt7) — validating

## CI

`.github/workflows/hexlet-check.yml` — auto-generated, do not edit. Runs `hexlet/project-action` on every push.
