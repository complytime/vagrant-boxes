#!/usr/bin/env bash

export LOAD_PATH=()
export SOURCED_FILES=()

function record_sourcing() {
  SOURCED_FILES+=("$1")
}

function source() {
  local source_file_path="$1"

  if [[ "${SOURCED_FILES[@]}" =~ "$source_file_path" ]]; then
    return 0
  fi

  record_sourcing "$source_file_path"

  builtin source "$@"
  local source_exit_code=$?

  return $source_exit_code
}

function _bootstrap_sourcing() {
  source "$(dirname ${BASH_SOURCE[0]})/array.bash"
  source "$(dirname ${BASH_SOURCE[0]})/logging.bash"
  source "$(dirname ${BASH_SOURCE[0]})/io.bash"
  #source "$(dirname ${BASH_SOURCE[0]})/traps.bash"

  local size=${#SOURCED_FILES[@]}
  local index=0
  for (( index = 0 ; index < size ; index++ )) ; do
    SOURCED_FILES[$index]="$(absolute_path "${SOURCED_FILES[$index]}")"
  done
}

_bootstrap_sourcing

function is_already_sourced_q() {
  if contains SOURCED_FILES $1 ; then
    return 0
  fi
  return 1
}

function source() {
  local source_file_path=`absolute_path $1`
  shift

  if is_already_sourced_q "$source_file_path" ; then
    [[ "${BASH_SOURCE[0]}" != "${BASH_SOURCE[1]}" ]] && debug "the file has already been sourced and will not be sourced again: $source_file_path"
    return 0
  fi

  [[ "${BASH_SOURCE[0]}" != "${BASH_SOURCE[1]}" ]] && debug "${BASH_SOURCE[1]} -> source(${source_file_path})"

  record_sourcing "$source_file_path"

  builtin source "$source_file_path" "$@"
  return $?
}

function require() {
  local source_file_path="$1"
  shift

  if is_already_sourced_q "$source_file_path" ; then
    [[ "${BASH_SOURCE[0]}" != "${BASH_SOURCE[1]}" ]] && debug "the file has already been sourced and will not be sourced again: $source_file_path"
    return 0
  fi

  [[ "${BASH_SOURCE[0]}" != "${BASH_SOURCE[1]}" ]] && debug "${BASH_SOURCE[1]} -> require(${source_file_path})"

  local source_exit_code=0
  if [[ -f "$source_file_path" ]]; then
    source_file_path=`absolute_path $source_file_path`
  elif [[ -f "$source_file_path.bash" ]]; then
    source_file_path=`absolute_path "$source_file_path.bash"`
  else
    local potential_load_dir=''
    for potential_load_dir in "${LOAD_PATH[@]}"
    do
      debug "looking for $source_file_path in $potential_load_dir"
      if [[ -f "$potential_load_dir/$source_file_path" ]]; then
        source_file_path="$potential_load_dir/$source_file_path"

        break
      elif [[ -f "$potential_load_dir/$source_file_path.bash" ]]; then
        source_file_path=`absolute_path "$potential_load_dir/$source_file_path.bash"`

        break
      fi
    done
  fi

  if [[ -f "$source_file_path" ]]; then
    source "$source_file_path" "$@"
    return $?
  fi

  fail "require failed to locate a file for '$source_file_path'"
}

function require_relative() {
  debug "${BASH_SOURCE[1]} -> require_relative(${@})"
  require "$(dirname ${BASH_SOURCE[1]})/$1"
  return $?
}

function add_directory_to_load_path() {
  if [[ "$#" -gt 1 ]]; then
    fail "add_directory_to_load_path accepts just one parameter, not: ${@}"
  fi
  local load_directory_path=`absolute_path $1`
  LOAD_PATH+=($load_directory_path)
}
