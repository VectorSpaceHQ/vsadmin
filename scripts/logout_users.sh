#!/bin/bash
# logout all users
# This script resides in /etc/cron.daily/, which executes at 630am

users=$(who | awk '{print $1}')

for user in $users
do
    echo $user
    pkill -u $user
done
