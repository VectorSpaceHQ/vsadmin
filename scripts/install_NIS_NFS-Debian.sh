#!/bin/bash
# This script makes the necessary modifications to mount the NFS share
# and enable NIS

if !(grep 'T5500b' /etc/hosts) then
   echo "# Mount common user file system from T5500b" >>/etc/fstab
   echo "T5500b:/vsfs01				/vsfs01		nfs	rw,async,_netdev,noauto,x-systemd.automount		0	0" >>/etc/fstab
   echo "+::::::" >>/etc/passwd
   echo "+:::" >>/etc/group
   echo "+::::::::" >>/etc/shadow
   echo "ypserver 10.0.0.150" >>/etc/yp.conf
   echo "10.0.0.150	T5500b" >>/etc/hosts
   mkdir -p /vsfs01

   # Arch
   sed -i 's/NISDOMAINNAME=".*/NISDOMAINNAME="vectorspace"/g' /etc/nisdomainname
fi
   echo "vectorspace" > /etc/defaultdomain

   sed -i 's/passwd:.*\(files\|compat\).*/passwd: files nis/g' /etc/nsswitch.conf
   sed -i 's/group:.*\(files\|compat\).*/group: files nis/g' /etc/nsswitch.conf
   sed -i 's/shadow:.*\(files\|compat\).*/shadow: files nis/g' /etc/nsswitch.conf


   # Debian
   /etc/init.d/portmap restart
   /etc/init.d/nis restart
   
   systemctl add-wants multi-user.target rpcbind.service

   # yptest
   mount -v /vsfs01
   echo "All Done!!"

