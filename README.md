# Overview

This repository contains automation for creating Vagrant Boxes for use as development, testing, and demo environments. It supports libvirt amd64 and VirtualBox arm64. They are published to the [complytime](https://portal.cloud.hashicorp.com/vagrant/discover/complytime) organization on the Hashicorp Vagrant registry.

## Building Boxes
As stated above there are to providers/architectures supported. They can only be built on bare metal of that architecture with that provider. You will need to have the following installed on you machine to build: Vagrant, the vagrant plugin for the provider, and the provider.

To build the vagrant box simply execute the make target build like so:

`make build`