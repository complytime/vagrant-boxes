#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../lib/control/bootstrap.bash"

export PACKAGE_BOX="$(absolute_path package.box)"

[[ -f "${PACKAGE_BOX}" ]]
fail_if "Package file doesn't exist: ${PACKAGE_BOX}"

cd "${ARCH}"

vagrant up