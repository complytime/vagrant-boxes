#!/usr/bin/env bash

sudo dnf install kernel-devel-$(uname -r) -y
sudo dnf groupinstall "Development Tools" -y
sudo dnf install dkms -y
sudo dnf clean all

wget http://download.virtualbox.org/virtualbox/7.1.6/VBoxGuestAdditions_7.1.6.iso
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro VBoxGuestAdditions_7.1.6.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions-arm64.run

sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions
rm VBoxGuestAdditions_7.1.6.iso