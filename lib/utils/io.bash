#!/usr/bin/env bash

function absolute_path()
{
  local partial_path="${@}"

  if [[ -d "$partial_path" ]]; then
    partial_path="$( cd "$partial_path" && pwd )"
  else
    local file_name=$(basename "$partial_path")
    partial_path="$( cd "$(dirname "$partial_path")" && pwd )/${file_name}"
  fi

  while [[ "$partial_path" =~ (.*)/.*/\.\.(.*) ]]
  do
    partial_path="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
  done

  partial_path="${partial_path//\/\///}"

  echo "$partial_path"
}

export -f absolute_path

function __DIR__() {
  absolute_path "$(dirname ${BASH_SOURCE[1]})"
}

function __FILE__() {
  absolute_path "${BASH_SOURCE[1]}"
}

function file__write() {
  local OPTIND=1

  local append=false

  local count=0
  local opt=''
  while getopts "a:" opt; do
    local count=$((count + 1))
    case "$opt" in
    a)  append=true
        ;;
    esac
  done

  shift $((count))

  [ "$1" = "--" ] && shift

  local output_file=$1
  shift
  local content=$1
  shift

  if [[ -z "$output_file" ]]; then
    fail "file path argument is required: -f [/path/to/file]"
  fi
  if [[ -n "$@" ]]; then
    fail "more arguments were passed than are accepted, additional arguments: ${*}"
  fi

  if [[ $append == false && -e "$output_file" ]]; then
    local remove_output=$(rm -f "$output_file")
    fail_if "failed to remove existing file: $output_file\n$remove_output" $?
  fi

  if [[ ! -e "$output_file" ]]; then
    local touch_output=$(touch "$output_file")
    fail_if "failed to create file: $output_file\n$touch_output" $?
  fi

  if [[ -z "$content" && ! -t 0 ]]; then
    local IFS=
    local data=''
    while read data ; do
      echo "$data" >> "$output_file"
    done
  elif [[ -n "$content" ]]; then
    echo "$content" >> "$output_file"
  else
    fail "nothing to write was passed"
  fi
}

export IO_STDOUT_TAG='[STDOUT]'
export IO_STDERR_TAG='[STDERR]'

function io__wrap() {
  local cmd="$1"
  shift
  local wrapper="$@"

  { { eval "$cmd"; } 2>&3 | io__wrap_pipe "$wrapper" "$IO_STDOUT_TAG"; return ${PIPESTATUS[0]}; } 3>&1 1>&2 | io__wrap_pipe "$wrapper" "$IO_STDERR_TAG"

  return ${PIPESTATUS[0]}
}

function io__wrap_pipe() {
  local wrapper="$@"

  local IFS=
  local line=''
  while read line ; do
    eval "$wrapper '$line'"
  done
}

function _io__tag_pipe_output() {
  echo "$@"
}

function io__store_merged_stdout_and_stderr() {
  cmd="$1"
  if [[ -n "$2" ]]; then
    tmp_file="$2"
  else
    tmp_file=$(mktemp -t `basename $0`)
    echo "$tmp_file"
  fi

  { io__wrap "$cmd" "_io__tag_pipe_output"; } > "$tmp_file" 2>&1

  exit_status=${PIPESTATUS[0]}

  return $exit_status
}
