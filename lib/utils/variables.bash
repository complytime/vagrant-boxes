#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/logging.bash"
source "$(dirname ${BASH_SOURCE[0]})/functions.bash"

function set_unless() {
  local var_name=$1
  local var_value=$2

  eval "
  if [[ -z \"\$$var_name\" ]]; then
    export $var_name=$var_value
  fi
  "
}

function variable__exist_q() {
  [[ -n "${!1}" ]]
}

function unset() {
  local var_name="$1"
  if variable__exist_q "$var_name" ; then
    builtin unset "$var_name"
  fi
}

function is_numeric() {
  if [[ -z "$1" ]]; then
    fail "one argument is required: is_numeric [variable]"
  fi

  if [[ $1 =~ ^[0-9]+$ ]]; then
    return 0
  fi
  return 1
}

function is_even() {
  if [[ -z "$1" ]]; then
    fail "one argument is required: is_even [variable]"
  fi
  local number=$1
  
  if ! is_numeric $number ; then
    fail "the argument passed must be numeric, was: $number"
  fi
  
  if [[ $((number % 2)) -eq 0 ]]; then
    return 0
  fi
  return 1
}