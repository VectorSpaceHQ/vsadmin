#!/bin/bash
cp ../hosts /etc/ansible/
ansible-playbook --become --ask-become-pass -u adam ../playbooks/add_client.yml

cp timeout.sh /etc/profile.d
