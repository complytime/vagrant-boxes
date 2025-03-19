ARCH="$(shell /opt/vagrant/embedded/bin/ruby lib/arch.rb)"

build:
	cd $(ARCH); \
		VAGRANT_STATUS="$$(vagrant status --machine-readable | grep ",state," | awk -F , '{print $$4}')"; \
		if [[ "$$VAGRANT_STATUS" == "not_created" ]]; then \
			vagrant up --no-provision; \
			ret_val=$$?; \
			if [[ $$ret_val != 0 ]]; then \
				>&2 echo "vagrant up failed"; \
				exit $$ret_val; \
			fi \
		fi; \
		vagrant provision; \
		ret_val=$$?; \
		if [[ $$ret_val != 0 ]]; then \
			>&2 echo "vagrant provision failed"; \
			exit $$ret_val; \
		fi
.PHONY: build

clean:
	cd $(ARCH) && vagrant destroy
.PHONY: clean