#!/bin/bash

# install ssh
# pacman -Syy openssh-server

# enable ssh
systemctl enable sshd

# activate ssh
systemctl start sshd

# copy public key
mkdir -p ~/.ssh

# cat ../id_rsa.pub >>  ~/.ssh/authorized_keys
# this is now done from the host using ssh-copy-id

# Add group sudo to sudoers file
sed -i 's/# %sudo/%sudo/g' /etc/sudoers
