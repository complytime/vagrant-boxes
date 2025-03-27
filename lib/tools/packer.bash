#!/usr/bin/env bash

function packer(){
  "$(which packer)" "$@"
  local packer_exit_code=$?
  
  rename_terminal
  fail_if "Failed to execute: packer ${*}" $packer_exit_code
}