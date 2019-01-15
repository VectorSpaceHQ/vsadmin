#!/bin/bash
ansible-playbook -i ../hosts -u root -K ../playbooks/initialize_client.yml -v --ask-pass
ansible-playbook -i ../hosts -u root -K ../playbooks/run_all.yml -vvv > run_all.log 2>&1
