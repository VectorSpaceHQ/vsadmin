#!/bin/bash

# install ssh
pacman -S sshd
apt-get install openssh-server

# enable ssh
systemctl enable sshd.service

# activate ssh
systemctl activate sshd.service

# copy public key
# ssh-copy-id -i id_rsa.pub ~/.ssh/
cp id_rsa.pub ~/.ssh/

# Add group sudo to sudoers file
# sed -i 's//g' /etc/sudoers
