#!/bin/bash

if [ "$#" -ne 1 ]
then
    echo "Error: one argument required"
    echo "Usage: host.sh username"
    exit 1
fi

user=$1

cp ../hosts /etc/ansible/
# cp ../scripts/logout_users.sh /etc/cron.daily/logout_users

# This order is important
ansible-playbook -u adam -K ../playbooks/run_all.yml -vvvv 2> run_all.log
# ansible-playbook -u adam -K ../playbooks/software.yml -vvvv 2> software.log
# ansible-playbook -u adam -K ../playbooks/config_client.yml -vvvv 2> config_client.log
# ansible-playbook -u adam -K ../playbooks/adduser.yml -vvvv 2> adduser.log

