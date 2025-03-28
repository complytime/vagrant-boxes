#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../lib/control/bootstrap.bash"

export BOX_FILE="$(absolute_path package.box)"

[[ -f "${BOX_FILE}" ]]
fail_if "Package file doesn't exist: ${BOX_FILE}"

vagrant up