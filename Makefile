.PHONY: help prepare-servers prepare-packages deploy

help:
	@echo "Available commands:"
	@echo "  prepare-servers    - Run Ansible playbook on all servers"
	@echo "  prepare-packages   - Install Ansible roles and collections"
	@echo "  deploy             - Deploy Redmine application"

prepare-servers:
	ansible-playbook playbook.yml -i inventory.ini

prepare-packages:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

deploy:
	ansible-playbook deploy.yml -i inventory.ini --vault-password-file ~/.vault_pass
