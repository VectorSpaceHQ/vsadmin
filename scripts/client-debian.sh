#!/bin/bash

# install ssh
apt-get install openssh-server

# enable ssh
systemctl enable ssh.service

# activate ssh
systemctl activate ssh.service

# copy public key
mkdir -p ~/.ssh
cat ../id_rsa.pub >>  ~/.ssh/authorized_keys

# Add group sudo to sudoers file
#sed -i 's/# %sudo/%sudo/g' /etc/sudoers
