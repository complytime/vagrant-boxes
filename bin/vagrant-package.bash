#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../lib/control/bootstrap.bash"

export BOX_FILE="$(absolute_path package.box)"

[[ ! -f "${BOX_FILE}" ]]
fail_if "Box file already exists: ${BOX_FILE}"

machine_id=$(machine_id)

cd "${ARCH}"

machine_exists
fail_if "The machine does not exist yet.
Looks like you haven't run make vagrant-build"

vagrant up --no-provision

vagrant ssh -c "$(cat ${PATHS_PROJECT_HOME}/provision/vagrant-ssh.sh)"
rm .vagrant/machines/default/virtualbox/private_key
fail_if "failed to delete the private_key: .vagrant/machines/default/virtualbox/private_key"

#vagrant halt

if [[ $ARCH == "arm64" ]]; then
  good "VBoxManage controlvm ${machine_id} shutdown"
  VBoxManage controlvm "${machine_id}" shutdown
  fail_if "error shutting machine down"

  while [[ true ]]; do
    running_vms="$(VBoxManage list runningvms)"
    fail_if "error collecting running vms"

    debug "${running_vms}"
    if echo "${running_vms}" | grep -v "${machine_id}" ; then
      good "vm is shutdown ${machine_id}"
      break;
    fi
  done
fi

vagrant package --base $machine_id --output "${BOX_FILE}"