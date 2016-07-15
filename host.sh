#!/bin/bash

cp hosts /etc/ansible/
ansible-playbook --become --ask-become-pass -u aspontarelli config_client.yml
ansible-playbook --become --ask-become-pass -u aspontarelli software.yml
