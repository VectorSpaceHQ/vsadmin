#!/bin/bash
ansible-playbook -i ../hosts -u adam -K ../playbooks/initialize_client.yml --ask-pass
ansible-playbook -i ../hosts -u adam -K ../playbooks/run_all.yml
# ansible-playbook -i ../hosts -u adam -K ../playbooks/reboot.yml -v
