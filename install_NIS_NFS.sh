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
   mkdir /vsfs01
   service nis restart
   service ypbind restart

   # Arch
   sed -i 's/NISDOMAINNAME=".*/NISDOMAINNAME="vectorspace"/g' /etc/nisdomainname
   echo "ypserver T5500b" >> /etc/yp.conf

   sed -i 's/passwd:.*files.*/passwd: files nis/g' /etc/nsswitch.conf
   sed -i 's/group:.*files.*/group: files nis/g' /etc/nsswitch.conf
   sed -i 's/shadow:.*files.*/shadow: files nis/g' /etc/nsswitch.conf

   systemctl enable rpcbind.service
   systemctl enable ypbind.service

   yptest
   mount -v /vsfs01
   echo "All Done!!"
fi
