
packer-build:
	bash bin/packer-build.bash
.PHONY: packer-build

vagrant-build:
	bash bin/vagrant-build.bash
.PHONY: vagrant-build

package:
	bash bin/vagrant-package.bash
.PHONY: package

clean-package:
	bash bin/vagrant-clean.bash
.PHONY: clean-package

clean-build:
	bash bin/vagrant-destroy.bash
.PHONY: clean-build

clean-base-box:
	bash bin/packer-clean.bash
.PHONY: clean-base-box

clean: clean-build clean-package clean-base-box

.PHONY: clean