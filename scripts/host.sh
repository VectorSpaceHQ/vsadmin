#!/bin/bash

# ansible-playbook -i ../hosts -u vectorspace -K ../playbooks/initialize_client.yml --ask-pass

ansible-playbook -i ../hosts -u vectorspace -K ../playbooks/run_all.yml -e 'ansible_python_interpreter=/usr/bin/python3'
#ansible-playbook -i ../hosts -u vectorspace -K ../playbooks/run_all.yml

# ansible-playbook -i ../hosts -u adam -K ../playbooks/reboot.yml -v
