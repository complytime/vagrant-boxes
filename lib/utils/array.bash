#!/usr/bin/env bash

function array__merge() {
  [[ -z "$1" && -z "$2" && -z "$3" ]] && fail "usage for function: array__merge [return_array_name] [array1_name] [array2_name]"
  local array_name="$1"
  ! declare -a | grep -q "${array_name}" && eval "${array_name}=()"

  eval local Array1=("\${${2}[@]}")
  eval local Array2=("\${${3}[@]}")
  eval "${array_name}+=(\"${Array2[@]}\")"

  local array1_item=''
  local skip=''
  local array2_item=''

  for array1_item in "${Array1[@]}"; do
      skip=
      for array2_item in "${Array2[@]}"; do
          [[ $array1_item == $array2_item ]] && { skip=1; break; }
      done
      [[ -n $skip ]] || eval "${array_name}+=(\"${array1_item}\")"
  done
}

function array__subtract() {
  [[ -z "$1" && -z "$2" && -z "$3" ]] && fail "usage for function: array__subtract [return_array_name] [array1_name] [array2_name]"
  local array_name="$1"
  ! declare -a | grep -q "${array_name}" && eval "${array_name}=()"

  eval local Array1=("\${${2}[@]}")
  eval local Array2=("\${${3}[@]}")

  local array1_item=0
  local skip=''
  local array2_item=0

  for array1_item in "${Array1[@]}"; do
      skip=
      for array2_item in "${Array2[@]}"; do
          [[ $array1_item == $array2_item ]] && { skip=1; break; }
      done
      [[ -n $skip ]] || eval "${array_name}+=(\"${array1_item}\")"
  done
}

function array__dump() {
  [[ -z "$1" ]] && fail "usage for function: array__dump [array_name] -> STDOUT"
  local array_name="$1"
  eval "printf '%s\n' \"${array_name[@]}\""
}

function array__parse() {
  [[ -z "$1" && -z "$2" ]] && fail "usage for function: array__parse [array_name] [string || PIPE]"

  local array_name="$1"
  ! declare -a | grep -q "${array_name}" && eval "${array_name}=()"

  if [[ -n "$3" ]]; then
    IFS="$3" eval "read -a $array_name <<< '$2'"
    return 0
  fi

  local raw=''
  local data=''
  if [[ -n "$2" ]]; then
    while read -r data; do
      if [[ -n "$raw" ]]; then
        raw="$data '$raw'"
      else
        raw="'$data'"
      fi
    done <<<"$2"
  fi

  if [[ -z "$raw" && ! -t 0 ]]; then
    while read data ; do
      if [[ -n "$raw" ]]; then
        raw="$data '$raw'"
      else
        raw="'$data'"
      fi
    done
  fi

  eval "${array_name}=(${raw})"
}

function array__reverse() {
  local arrayname=${1:?Array name required} array reverse_array item
  eval "array=( \"\${$arrayname[@]}\" )"
  
  for item in "${array[@]}"
  do
    reverse_array=("$item" "${reverse_array[@]}")
  done

  eval "$arrayname=( \"\${reverse_array[@]}\" )"
}

function contains() {
  local array_name="$1"
  local query_item="$2"

  eval "local item=''
  for item in \"\${$array_name[@]}\" ; do
    if [[ \"\$item\" == \"$query_item\" ]]; then
      return 0
    fi
  done"
  return 1
}

index_exists(){
  local index=$1
  local array_name=$2
  if ! [[ $index =~ ^[0-9]+$ ]] ; then
    fail "first parameter, index, was not a whole positive number $index"
  fi

  let "index++"

  local array_length=''
  eval array_length="\${#$array_name[@]}"

  if [[ $index -gt 0 && $index -le $array_length ]]; then
    return 0
  else
    return 1
  fi
}