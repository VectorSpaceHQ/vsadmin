#!/bin/bash

if [ "$#" -ne 1 ]
then
    echo "Error: one argument required"
    echo "Usage: host.sh username"
    exit 1
fi

user=$1

cd ..
cp hosts /etc/ansible/
cp scripts/logout_users.sh /etc/cron.daily/logout_users

ansible-playbook --become --ask-become-pass -u $user playbooks/config_client.yml -vvvv > config_client.log
ansible-playbook --become --ask-become-pass -u $user playbooks/software.yml -vvvv > software.log
