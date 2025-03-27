#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../lib/control/bootstrap.bash"

export BOX_FILE="$(absolute_path ${ARCH}/centos-stream-10.box)"

if [[ -f "${BOX_FILE}" ]]; then
  rm "${BOX_FILE}"
  fail_if "error deleting: ${BOX_FILE}"
fi
