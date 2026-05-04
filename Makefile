.PHONY: help prepare-servers prepare-packages install

help:
	@echo "Available commands:"
	@echo "  prepare-servers    - Run Ansible playbook on all servers"
	@echo "  prepare-packages   - Install Ansible roles and collections"

prepare-servers:
	ansible-playbook playbook.yml -i inventory.ini

prepare-packages:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml
