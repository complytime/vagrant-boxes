#!/usr/bin/env bash

function provider(){
  if [[ $ARCH == "arm64" ]]; then
    echo "virtualbox"
  else
    echo "libvirt"
  fi
}

function machine_id_file(){
  debug "${ARCH}/.vagrant/machines/default/$(provider)/id"
  echo "${ARCH}/.vagrant/machines/default/$(provider)/id"
}

function machine_id(){
  cat "$(machine_id_file)"
}

function machine_exists(){
  [[ ! -f "$(machine_id_file)" ]]
}

function vagrant_status(){
  vagrant status --machine-readable | grep ",state," | awk -F , '{print $$4}'
  fail_if
}

function vagrant(){
  good "$(which vagrant) $@"
  "$(which vagrant)" "$@"
  local vagrant_exit_code=$?

  rename_terminal
  fail_if "Failed to execute: vagrant ${*}" $vagrant_exit_code
}