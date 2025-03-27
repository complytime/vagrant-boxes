#!/usr/bin/env bash

function provider(){
  if [[ $ARCH == "arm64" ]]; then
    echo "virtualbox"
  else
    echo "libvirt"
  fi
}

export PROVIDER="$(provider)"
export MACHINE_ID_FILE="${ARCH}/.vagrant/machines/default/${PROVIDER}/id"
export MACHINE_ID="$(cat ${MACHINE_ID_FILE})"

function vagrant_status(){
  vagrant status --machine-readable | grep ",state," | awk -F , '{print $$4}'
  fail_if
}

function vagrant(){
  "$(which vagrant)" "$@"
  local vagrant_exit_code=$?

  rename_terminal
  fail_if "Failed to execute: vagrant ${*}" $vagrant_exit_code
}