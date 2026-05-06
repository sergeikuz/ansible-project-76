.PHONY: help prepare-servers prepare-packages deploy vault-edit vault-view

help:
	@echo "Available commands:"
	@echo "  prepare-servers    - Setup servers (Docker, pip, DataDog)"
	@echo "  prepare-packages   - Install Ansible roles and collections"
	@echo "  deploy             - Deploy Redmine application"
	@echo "  vault-edit         - Edit vault secrets"
	@echo "  vault-view         - View vault secrets"

prepare-servers:
	ansible-playbook playbook.yml -i inventory.ini

prepare-packages:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

deploy:
	ansible-playbook deploy.yml -i inventory.ini

vault-edit:
	ansible-vault edit group_vars/webservers/vault.yml

vault-view:
	ansible-vault view group_vars/webservers/vault.yml 2>/dev/null || cat group_vars/webservers/vault.yml
