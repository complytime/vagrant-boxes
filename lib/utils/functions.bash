#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/array.bash"

export FUNCTION_EXPORT_EXCLUDES=()

function functions__exclude_from_export(){
  local function_name=''
  for function_name in "$@" ; do
    FUNCTION_EXPORT_EXCLUDES+=("$function_name")
  done
}

function functions__export_functions() {
  functions__exclude_from_export 'function.export_functions' 'function.exclude_from_export'

  local IFS=
  local data=''
  tmp_file="${PATHS_TMP_DIR}/$$_declared_functions"
  declare -f | grep '^\w.*)\s$' | grep -v '^declare\s' > "$tmp_file"
  while read data ; do
    if [[ $data =~ ^(.*)[[:space:]]+\(\) ]]; then
      if ! contains FUNCTION_EXPORT_EXCLUDES "${BASH_REMATCH[1]}" ; then
        local function_name="${BASH_REMATCH[1]}"
        export -f "${function_name}"
      fi
    fi
  done  < "${tmp_file}"

  rm -f "${tmp_file}"

  return 0
}

function function__get_calling_function_name() {
  local caller_info=`caller 1`

  [[ $caller_info =~ (-{0,1}[[:digit:]]+)[[:blank:]]+([^ ]+)[[:blank:]]+(.*) ]]

  echo "${BASH_REMATCH[2]}"
}

function function__exist_q() {
  declare -f "$1" 1>/dev/null 2>&1
}

function function__execute_if_exists() {
  local function_name="$1"

  if function__exist_q "$function_name" ; then
    eval "${*}"
  fi
}

function function__copy() {
  test -n "$(declare -f $1)" || return
  eval "${_/$1/$2}"
}

function function__rename() {
  function__copy $@ || return
  unset -f $1
}
