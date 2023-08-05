#!/bin/bash
# logout all users who have been logged in for more than 8 hours
# when current time is less than 5am
# run hourly cron job

echo "" >> /var/log/logout_idle_user.log
echo $(date) >> /var/log/logout_idle_user.log

IFS='
'
for line in `who -u`
do
    user=$(echo $line|awk '{print $1}')
    login_date=$(echo $line|awk '{print $3}')
    login_date=$(echo $login_date | awk -F  '-' '{print $2$3}') # format %m%d, eg. 0409
    login_date=$(echo $login_date | sed 's/^0*//')
    login_time=$(echo $line|awk '{print $4}')
    login_time=${login_time//:}
    current_date=$(date +"%m%d")
    current_date=$(echo $current_date | sed 's/^0*//')
    current_time=$(date +"%H%M")
    current_time=${current_time//:}
    minutes_logged=$(expr $current_time - $login_time)
    # add in the days elapsed
    minutes_elapsed=$(python3 -c "print($minutes_logged + 60*2*($current_date - $login_date))")
    echo "user, login time, current time, minutes logged"
    echo $user, $login_date, $current_date, $login_time, $current_time, $minutes_logged, $minutes_elapsed

    if [ $minutes_elapsed -gt 500 ] || [ $minutes_logged -lt 0 ]; # logged in more than 500 minutes
    then
	echo $user " LOGGED in too long" >> /var/log/logout_idle_user.log
        echo "Current time is " $current_time >> /var/log/logout_idle_user.log
	echo "User has been logged in for " $minutes_logged >> /var/log/logout_idle_user.log
        if [ $current_time -lt 500 ]; # 5am
        then
            echo "Time is less than 5am, goodbye" >> /var/log/logout_idle_user.log
	    # pkill -u $user
        fi
    fi
done
