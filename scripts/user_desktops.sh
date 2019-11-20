#!/bin/bash
# Go through every user and add convenient shortcuts to their desktops

set -e
for LDAP_USER in $(ls /vsfs01/home)
do
    if [ -n "`getent passwd $LDAP_USER`" ]; then
        echo $LDAP_USER

        mkdir -p /vsfs01/home/$LDAP_USER/Desktop
        chown $LDAP_USER:members /vsfs01/home/$LDAP_USER/Desktop

        if [ ! -L /vsfs01/home/$LDAP_USER/Desktop/share ]; then
            ln -s  /vsfs01/share /vsfs01/home/$LDAP_USER/Desktop/share
        fi

        if [ ! -L /vsfs01/home/$LDAP_USER/Desktop/fonts ]; then
            ln -s /vsfs01/home/$LDAP_USER/.local/share/fonts /vsfs01/home/$LDAP_USER/Desktop/fonts
        fi

        if [ ! -d /vsfs01/home/$LDAP_USER/.config/LightBurn ]; then
            cp -r /vsfs01/home/aspontarelli/ansible/config_files/LightBurn /vsfs01/home/$LDAP_USER/.config
            echo "COPYING LIGHTBURN for $LDAP_USER"
        fi
        
        cp /vsfs01/home/aspontarelli/ansible/config_files/passwd.desktop /vsfs01/home/$LDAP_USER/Desktop
        cp /vsfs01/home/aspontarelli/ansible/config_files/LuBan.desktop /vsfs01/home/$LDAP_USER/Desktop
        cp /vsfs01/home/aspontarelli/ansible/config_files/LightBurn.desktop /vsfs01/home/$LDAP_USER/Desktop

        echo "locking desktop"
        chmod 555 /vsfs01/home/$LDAP_USER/Desktop/
        echo "DONE"
    fi

done
