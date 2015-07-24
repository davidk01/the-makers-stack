#!/bin/bash
if [[ ! -e VBoxGuestAdditions_4.3.28.iso ]]; then
  wget -q http://dlc-cdn.sun.com/virtualbox/4.3.28/VBoxGuestAdditions_4.3.28.iso &
  yum -y -q install kernel-devel-$(uname -r)
  cp /vagrant/guest-additions.sh .
fi
export KERN_DIR="/usr/src/kernels/3.10.0-229.4.2.el7.x86_64/"
mkdir /media/VBoxGuestAdditions
mount -o loop,ro *.iso /media/VBoxGuestAdditions
sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
umount /media/VBoxGuestAdditions
