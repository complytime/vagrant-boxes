ARCH="$(shell if [[ $$(uname -m) == "arm64" ]]; then echo "arm64"; else echo "amd64"; fi)"
PROVIDER="$(shell if [[ $(ARCH) == "arm64" ]]; then echo "virtualbox"; else echo "libvirt"; fi)"
VAGRANT_STATUS="$(shell cd $(ARCH) && vagrant status --machine-readable | grep ",state," | awk -F , '{print $$4}')"
MACHINE_ID_FILET=$(ARCH)/.vagrant/machines/default/$(PROVIDER)/id
MACHINE_ID_FILE=$(shell echo $(MACHINE_ID_FILET))
MACHINE_ID="$(shell cat $(MACHINE_ID_FILE))"

start:
	cd $(ARCH); \
		if [[ $(VAGRANT_STATUS) == "not_created" || $(VAGRANT_STATUS) == "poweroff" ]]; then \
			vagrant up --no-provision; \
			ret_val=$$?; \
			if [[ $$ret_val != 0 ]]; then \
				>&2 echo "vagrant up failed"; \
				exit $$ret_val; \
			fi \
		fi
.PHONY: start

stop:
	cd $(ARCH); \
		if [[ $(VAGRANT_STATUS) == "running" ]]; then \
			vagrant halt; \
			ret_val=$$?; \
			if [[ $$ret_val != 0 ]]; then \
				>&2 echo "vagrant halt failed"; \
				exit $$ret_val; \
			fi \
		fi
.PHONY: stop

build-base-box:
	cd $(ARCH); \
		packer build -force centos-stream-10.pkr.hcl; \
		ret_val=$$?; \
		if [[ $$ret_val != 0 ]]; then \
			>&2 echo "vagrant provision failed"; \
			exit $$ret_val; \
		fi
.PHONY: build-base-box

build: start
	cd $(ARCH); \
		vagrant provision; \
		ret_val=$$?; \
		if [[ $$ret_val != 0 ]]; then \
			>&2 echo "vagrant provision failed"; \
			exit $$ret_val; \
		fi
.PHONY: build

package: stop
	if [[ -f $(MACHINE_ID_FILE) ]]; then \
		cd $(ARCH); \
		vagrant package --base $(MACHINE_ID) --output ../package.box; \
		ret_val=$$?; \
		if [[ $$ret_val != 0 ]]; then \
			>&2 echo "vagrant package failed"; \
			exit $$ret_val; \
		fi \
	else \
		echo "You need to build the box before you can package it."; \
	fi
.PHONY: package

clean-package:
	rm package.box
.PHONY: clean-package

clean-build:
	cd $(ARCH) && vagrant destroy
.PHONY: clean-build

clean-base-box:
	cd $(ARCH) && rm centos-stream-10.box
.PHONY: clean-base-box

clean: clean-build clean-package clean-base-box

.PHONY: clean