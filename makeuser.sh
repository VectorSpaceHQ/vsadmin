#!/bin/bash
username=$1
sudo useradd $username -G lock,uucp,dialout,member,optical,lp,power,network,storage
sudo mkdir /vsfs01/home/${username}
sudo chown -R ${username}:member /vsfs01/home/${username}
echo "${username}:temp123" | sudo chpasswd
cd /var/yp
sudo make
