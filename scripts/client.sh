#!/bin/bash

# install ssh
pacman -S sshd
apt-get install openssh-server

# enable ssh
systemctl enable sshd.service

# activate ssh
systemctl activate sshd.service

# copy public key
cp ../id_rsa.pub ~/.ssh/

# Add group sudo to sudoers file
sed -i 's/# %sudo/%sudo/g' /etc/sudoers

