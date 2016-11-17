#!/bin/bash
cp hosts /etc/ansible/
ansible-playbook --become --ask-become-pass -u adam software.yml
