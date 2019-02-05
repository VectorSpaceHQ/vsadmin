#!/bin/bash
# Add all LDAP users to local groups

echo "Adding members to local groups"

for LDAP_USER in $(ls /vsfs01/home)
do
    if [ -n "`getent passwd $LDAP_USER`" ]; then
        echo $LDAP_USER
        USER_GROUPS=`groups $LDAP_USER`
        if [[ $USER_GROUPS = *"members"* ]]; then
            echo "Adding $LDAP_USER to groups"
            usermod -a -G uucp,lock,lp,video,optical,network,storage,audio $LDAP_USER
            usermod -a -G dialout $LDAP_USER
            usermod -a -G plugdev $LDAP_USER
            usermod -a -G cdrom $LDAP_USER
        fi

        if [[ $USER_GROUPS = *"admins"* ]]; then
            echo "Adding $LDAP_USER to admin groups"
            usermod -a -G wheel $LDAP_USER
            usermod -a -G sys $LDAP_USER
            usermod -a -G sudo $LDAP_USER
        fi
    fi
done
