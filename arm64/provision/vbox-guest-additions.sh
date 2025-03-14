#!/usr/bin/env bash

VBOX_VERSION="7.1.6"

sudo dnf install kernel-devel-$(uname -r) -y
sudo dnf groupinstall "Development Tools" -y
sudo dnf install dkms -y
sudo dnf clean all

wget "http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/VBoxGuestAdditions_${VBOX_VERSION}.iso"
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro "VBoxGuestAdditions_${VBOX_VERSION}.iso" /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions-arm64.run

sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions
rm "VBoxGuestAdditions_${VBOX_VERSION}.iso"