#!/bin/bash
username=$1
sudo useradd $username -g member -G lock,uucp,dialout
sudo mkdir /vsfs01/home/${username}
sudo chown -R ${username}:member /vsfs01/home/${username}
echo "${username}:temp123" | sudo chpasswd
cd /var/yp
sudo make
