#!/bin/bash

ansible-playbook -i ../hosts -u adam -K ../playbooks/run_all.yml -vvv > run_all.log 2>&1
