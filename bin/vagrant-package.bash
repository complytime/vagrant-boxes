#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../lib/control/bootstrap.bash"

export BOX_FILE="$(absolute_path package.box)"

[[ ! -f "${BOX_FILE}" ]]
fail_if "Box file already exists: ${BOX_FILE}"

cd "${ARCH}"

# check that machine exists
# address vagrant ssh
# stop machine
vagrant package --base $(MACHINE_ID) --output "${BOX_FILE}"