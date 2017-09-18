#!/bin/bash

ansible-playbook -i ../hosts -u adam -K ../playbooks/run_all.yml -vvv 2> run_all.log
