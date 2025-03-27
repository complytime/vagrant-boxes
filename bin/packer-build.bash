#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../lib/control/bootstrap.bash"

export BOX_FILE="$(absolute_path ${ARCH}/centos-stream-10.box)"

[[ ! -f "${BOX_FILE}" ]]
fail_if "Box file already exists: ${BOX_FILE}"

cd "${ARCH}"

packer build -force centos-stream-10.pkr.hcl