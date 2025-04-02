#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../lib/control/bootstrap.bash"

cd "${ARCH}"

if [[ $ARCH != "amd64" ]]; then
  export BOX_FILE="$(absolute_path centos-stream-10.box)"

  [[ -f "${BOX_FILE}" ]]
  fail_if "Package file doesn't exist: ${BOX_FILE}"
fi

vagrant up --no-provision

vagrant provision