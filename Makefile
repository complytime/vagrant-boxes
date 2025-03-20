VAGRANT_RUBY="$(shell if [[ $$(uname) == "Darwin" ]]; then echo "/opt/vagrant/embedded/bin/ruby"; else echo "/var/lib/vagrant/bin/ruby"; fi)"
ARCH="$(shell ${VAGRANT_RUBY} lib/arch.rb)"
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
	cd $(ARCH); \
		if [[ -f $(MACHINE_ID_FILE) ]]; then \
			vagrant package --base $(MACHINE_ID); \
			ret_val=$$?; \
			if [[ $$ret_val != 0 ]]; then \
				>&2 echo "vagrant package failed"; \
				exit $$ret_val; \
			fi \
		else \
			echo "You need to build the box before you can package it."; \
		fi	
.PHONY: package

clean:
	cd $(ARCH) && vagrant destroy
.PHONY: clean