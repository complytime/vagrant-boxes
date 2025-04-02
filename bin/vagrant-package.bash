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

vagrant halt

vagrant package --base $machine_id --output "${BOX_FILE}"