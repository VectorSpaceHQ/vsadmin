#!/bin/bash

if [ "$#" -ne 1 ]
then
    echo "Error: one argument required"
    echo "Usage: host.sh username"
    exit 1
fi

user=$1

cp hosts /etc/ansible/
ansible-playbook --become --ask-become-pass -u $user config_client.yml -vvvv > config_client.log
ansible-playbook --become --ask-become-pass -u $user software.yml -vvvv > software.log
