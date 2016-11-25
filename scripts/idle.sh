#!/bin/bash
# logout any user who has been idle for at least 1 day

idle=$(w | grep -G ' [1-9][0-9]:[0-9][0-9] ' | awk '{print $1}')
idle=$(w | grep -G ' [1-9]days ' | awk '{print $1}')
for user in $idle
do
    echo $user
    pkill -u $user
done

# long names get truncated
full_name=`who | grep -E -o '$user\w+ '`
echo $full_name
