# AGENTS.md

## Project

Hexlet Ansible project — deploys Docker + app infrastructure to two Yandex Cloud VMs via SSH.

## Critical constraints

- **`playbook.yml` must use `hosts: all`** — required by Hexlet auto-checker
- **`requirements.yml` must declare all Galaxy roles and collections** used in the playbook
- **Inventory must contain a `webservers` group** — required by auto-checker

## Commands

```bash
make prepare-packages   # Install Galaxy roles + collections (run first)
make prepare-servers    # Run playbook on all hosts
ansible all -i inventory.ini -m ping  # Quick connectivity check
```

Order: `prepare-packages` → `prepare-servers`

## SSH details

- User: `mrkuzy9999`
- Key: `~/.ssh/id_rsa`
- `StrictHostKeyChecking=no` set in `[webservers:vars]`
- VMs are in Yandex Cloud; public IPs may change on stop/restart — update `inventory.ini` if they do

## Playbook gotchas

- **`become: true` is required** — apt/docker tasks need root
- **`pre_tasks: apt update_cache` is required** — without it, `docker-ce` package is not found on fresh cache (seen on Ubuntu 24.04)

## File structure

| File | Purpose |
|---|---|
| `playbook.yml` | Main playbook (hosts: all) |
| `inventory.ini` | Host definitions (webservers group) |
| `requirements.yml` | Galaxy roles + collections |
| `group_vars/all/vars.yml` | Shared variables |
| `group_vars/webservers.yml` | Webserver-specific variables |

## CI

`.github/workflows/hexlet-check.yml` — auto-generated, do not edit. Runs `hexlet/project-action` on every push.
