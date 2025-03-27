#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/variables.bash"
source "$(dirname ${BASH_SOURCE[0]})/io.bash"
source "$(dirname ${BASH_SOURCE[0]})/colors.bash"

if [[ -z "$DEBUG" ]]; then
  export DEBUG=false
fi

function error(){
  local message="$@"
  if [[ -z "$message" && ! -t 0 ]]; then
    local IFS=
    local data=''
    while read data ; do
      message="$data$message"
    done
  fi

  if [[ -n "$message" ]]; then
    >&2 echo "$(colorize -t $RED "$message")"
  fi
  return
}

function good(){
  local message="$@"
  if [[ -z "$message" && ! -t 0 ]]; then
    local IFS=
    local data=''
    while read data ; do
      message="$data$message"
    done
  fi

  if [[ -n "$message" ]]; then
    echo "$(colorize -t $GREEN "$message")"
  fi
  return
}

function debug(){
  if [[ $DEBUG == true ]]; then
    local message="$@"
    if [[ -z "$message" && ! -t 0 ]]; then
      local IFS=
      local data=''
      while read data ; do
        message="$data$message"
      done
    fi

    if [[ -n "$message" ]]; then
      >&2 echo "$(colorize -t $BLUE "$message")"
    fi
  fi
  return
}

function warn(){
  local message="$@"
  if [[ -z "$message" && ! -t 0 ]]; then
    local IFS=
    local data=''
    while read data ; do
      message="$data$message"
    done
  fi

  if [[ -n "$message" ]]; then
    >&2 echo "$(colorize -t $YELLOW "$message")"
  fi
  return
}

function fail(){
  local message="$1"
  if [[ -z "$message" && ! -t 0 ]]; then
    local IFS=
    local data=''
    while read data ; do
      message="$data$message"
    done
  fi

  error "$message"
  backtrace -s 1

  _bail
}

function fail_if(){
  local condition=$?
  local message="$1"

  if [[ -n "$2" ]]; then
    condition=$2
  fi

  if [[ -z "$message" ]]; then
    fail "one or two arguments are required: fail_if [message] [condition | \$?]"
  fi

  if [[ -z "$message" && ! -t 0 ]]; then
    local IFS=
    local data=''
    while read data ; do
      message="$data$message"
    done
  fi

  if [[ $condition != 0 ]]; then
    fail "$message"
  fi
}

function _bail() {
  if variable__exist_q "$BASHPID" ; then
    local target=$BASHPID
  else
    local target=$$
  fi

  set +x

  kill -s INT $target
}

export _REMEMBER_SKIP_BACKTRACE=0

function backtrace() {
  local OPTIND=1

  local padding=4
  local skip_callers=0

  local opt=''
  local OPTARG=''
  while getopts "p:s:" opt; do
    case "$opt" in
    p)  padding="$OPTARG"
        ;;
    s)  skip_callers="$OPTARG"
        ;;
    esac
  done

  local var=''
  for var in padding skip_callers ; do
    if ! is_numeric ${!var} ; then
      error "option -${var::1} value must be numeric, was ${!var}"
      _bail
    fi
  done

  local header_padding=$padding
  if ! is_even $padding ; then
    header_padding=$((padding-1))
  fi

  header_padding=$((header_padding/2))

  if [[ $header_padding == 1 ]]; then
    header_padding=0
  fi

  local header="$(printf "%-${header_padding}s %s" "")trace:"
  header=${header:1}

  local padding_string=$(printf "%-${padding}s %s" "")
  padding_string=${padding_string:1}

  local skip_callers_plus_self=$(expr ${skip_callers} + 1)
  local trace=""
  local cumulative_stack_size=${#FUNCNAME[@]}
  local stack_size=$(expr ${cumulative_stack_size} - ${_REMEMBER_SKIP_BACKTRACE})

  local count=1
  for (( i=$skip_callers_plus_self ; i<$stack_size ; i++ )); do
    local func_name="${FUNCNAME[$i]}"
    [[ -z "$func_name" || "$func_name" == "main" ]] && break

    #local line_number="${BASH_LINENO[$i]}"

    local file_path="$(absolute_path "${BASH_SOURCE[$i]}")"
    [ -z "$file_path" ] && file_path="eval"

    ((count++))
    trace="${trace}
${padding_string}${file_path}: ${func_name}"
  done

  _REMEMBER_SKIP_BACKTRACE=$(expr ${_REMEMBER_SKIP_BACKTRACE} + $cumulative_stack_size - $skip_callers)

  >&2 echo "$(colorize -t $MAGENTA "$header$trace")"
}
