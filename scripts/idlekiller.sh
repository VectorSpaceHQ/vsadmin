#! /bin/bash

# Width of username column in w's output
export PROCPS_USERLEN=32

IDLE=$((20*60))	# 20 min
SOFT_LIMIT=$((10*60)) # 10 min
HARD_LIMIT=$((60*60))	# 60 min
GRACE=1s			# 1 minutes
TIMEOUT=5s

IDLE_MESSAGE="You have been idle for more than $(($IDLE / 60)) minutes. \
You will be logged out in $GRACE if no activity is detected."

[ -f /etc/default/idlekiller ] && . /etc/default/idlekiller

declare -gA watched_users
declare -gA idle_time
declare -gA idle_seat

# Log to syslog with tag "IDLEKILLER"
log ()
{
	logger -t "IDLEKILLER" -i -- "$@"
}

get_xidle ()
{
    local user=$1
    local seat=$2

    echo "xidle $user $seat" 
    
    # If xprintidle doesn't return number, they're not logged into X11
    xidle=$(sudo -u $user DISPLAY=$seat xprintidle)
    re='^[0-9]+$'
    if [[ $xidle =~ $re ]] ; then
        echo $(($xidle / 1000))
    else
        echo 0
    fi
}


# For a console user, `w` prints IDLE time in as: 
# "DDdays, HH:MMm, MM:SS or SS.CC if the times are 
# greater than 2 days, 1hour, or 1 minute respectively."
# For the X session, `w` reports an IDLE time of ?xdm?,
# so we use the `xprintidle` command, which returns idle 
# time in milliseconds. We convert all this to seconds.
parse_idle ()
{
	local user=$1
	local seat=$3

        # If xprintidle doesn't return number, they're not logged into X11
	xidle=$(sudo -u $user DISPLAY=$seat xprintidle)
        re='^[0-9]+$'
        if [[ $xidle =~ $re ]] ; then
            echo $(($xidle / 1000))
        else
            echo 0
        fi
}

# Given an idle user and session, notify the user in *that session*
# and go to sleep for the grace period. Then check if the user had 
# made any activity in *that session*. If not, kill them all.
grace ()
{
	local user=$1
	local seat=$2
	local idle=$3

	notify_user $user $seat $idle
	sleep $GRACE

        echo "GRACE"

	# Get the new idle time for this session.
	new_idle=$(parse_idle $(w -hs $user))
	echo $user is now idle for $new_idle seconds.
	if [[ $new_idle -gt $SOFT_LIMIT ]]
	then
            echo "$user exceeded SOFT LIMIT"
            sudo -u $user DISPLAY=$seat gdmflexiserver&
        elif [[ $new_idle -gt $HARD_LIMIT ]] # Logout user
        then
            echo "$user exceeded HARD LIMIT"
	     # For root, special considerations. :)
	     if [[ $user == root ]]
	     then
		 if [[ $seat =~ :[0-9]+ ]]
		 then
		     DISPLAY=$seat gnome-session-quit --logout --no-prompt
		 else
		     pkill -u $user -t $seat
		 fi
	     else
		 # Everyone else can die.
		 pkill -KILL -u $user
	     fi
	     log "Idle session of $user at $seat has been terminated."            
	fi
}

# Use `notify-send` for the GUI and `write` for the TTYs.
notify_user ()
{
	local user=$1
	local seat=$2
	local idle=$3

	if [[ $seat =~ :[0-9]+ ]]
	then
		/usr/bin/sudo -u $user DISPLAY=$seat \
			notify-send --urgency critical "$IDLE_MESSAGE"
	else
		write $user $pts <<< "$IDLE_MESSAGE"
	fi
	log "Notifying $user at $seat."
}

while sleep $TIMEOUT # Loop indefinitely.
do

	# If the terminal is a pts (pseudo-terminal), then the user is 
	# actually logged in from either X, or from SSH. We will leave 
	# SSH sessions alone (to be handled by SSHD configuration, and 
	# only look at TTY sessions and X sessions.
	
    	while read user w_idle seat what
	do
		# If the user has already been recorded as idle, continue. 
		[[ -n ${watched_users["$user"]} ]] && continue

		idle=$(parse_idle $user $w_idle $seat)
                echo $user $seat $w_idle $idle
		[[ -z ${idle_time["$user"]} ]] && idle_time["$user"]=$idle

		# Store the smallest idle time for each user.
		if [[ $idle -le ${idle_time["$user"]} ]]
		then
			idle_time["$user"]=$idle
			idle_seat["$user"]=$seat
		fi
	done < <(w -hs | grep -v pts)
	
	echo Idle users: ${!watched_users[@]}

	# Loop over the minimum idle time of each user
	for user in "${!idle_time[@]}"
	do
		idle=${idle_time["$user"]}
		seat=${idle_seat["$user"]}
		unset -v idle_seat["$user"]
		unset -v idle_time["$user"]

		# If the user has already been recorded as idle, continue. 
		[[ -n ${watched_users["$user"]} ]] && continue
		if [[ $idle -gt $SOFT_LIMIT ]]
		then
			grace $user $seat $idle &
			watched_users["$user"]=$!
			echo $user has been idle for over "$idle" seconds - kill job: ${watched_users["$user"]}.
		fi
	done

	# Check if kill jobs have ended.
	for user in ${!watched_users[@]}
	do
		if ! kill -0 ${watched_users["$user"]}  2>/dev/null
		then
			unset -v watched_users["$user"]
		fi
	done
done
