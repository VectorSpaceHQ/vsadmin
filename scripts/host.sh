#!/bin/bash

ansible-playbook -i ../hosts -u root -K ../playbooks/run_all.yml -vvv > run_all.log 2>&1
