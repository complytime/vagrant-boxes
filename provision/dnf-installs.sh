#!/usr/bin/env bash

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm -y
sudo dnf install wget -y
sudo dnf install curl -y
sudo dnf install sudo -y
sudo dnf clean all