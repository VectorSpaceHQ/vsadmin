#!/bin/bash

# ssh-copy-id -i ~/.ssh/id_rsa.pub adam@laser

# ansible-playbook -i ../hosts -u vectorspace -K ../playbooks/initialize_client.yml --ask-pass
ansible-playbook -i ../hosts -u vectorspace -K ../playbooks/run_all.yml
# ansible-playbook -i ../hosts -u adam -K ../playbooks/reboot.yml -v

