#!/usr/bin/env bash

##############################################################
#                              #
#   https://wiki.archlinux.org/index.php/Color_Bash_Prompt   #
#                              #
##############################################################

export RED='1'
export GREEN='2'
export YELLOW='3'
export BLUE='4'
export MAGENTA='5'
export CYAN='6'
export LIGHT_GRAY='7'
export GRAY='8'
export LIGHT_RED='9'
export LIGHT_GREEN='10'
export LIGHT_YELLOW='11'
export LIGHT_BLUE='12'
export LIGHT_MAGENTA='13'
export LIGHT_CYAN='14'

export CLEAR='\033[0m'

function clear_color(){
  local OPTIND=1

  local escape='false'

  local opt=''
  local OPTARG=''
  while getopts "e:" opt; do
    case "$opt" in
      e)
        escape="$OPTARG"
      ;;
    esac
  done

  shift $((OPTIND-1))

  if [[ "$escape" == 'true' ]]; then
    echo -n "\[$CLEAR\]"
  else
    echo -en "\001$CLEAR\002"
  fi
}

function background_color_code(){
  local OPTIND=1

  local escape='false'
  
  local opt=''
  local OPTARG=''
  while getopts "e:" opt; do
    case "$opt" in
      e)
        escape="$OPTARG"
      ;;
    esac
  done
  
  shift $((OPTIND-1))
  
  if [[ "$escape" == 'true' ]]; then
    echo -n "\[\033[48;5;${1}m\]"
  else
    echo -en "\001\033[48;5;${1}m\002"
  fi
}

function text_color_code(){
  local OPTIND=1
  
  local escape='false'
  
  local opt=''
  local OPTARG=''
  while getopts "e:" opt; do
    case "$opt" in
      e)
        escape="$OPTARG"
      ;;
    esac
  done
  
  shift $((OPTIND-1))
  
  if [[ "$escape" == 'true' ]]; then
    echo -n "\[\033[38;5;${1}m\]"
  else
    echo -en "\001\033[38;5;${1}m\002"
  fi
}

function colorize(){
  local OPTIND=1
  
  local background_color=''
  local text_color=''
  local escape=false
  
  local opt=''
  local OPTARG=''
  while getopts "b:t:e:" opt; do
    case "$opt" in
      b)
        background_color="$OPTARG"
      ;;
      t)
        text_color="$OPTARG"
      ;;
      e)
        escape="$OPTARG"
      ;;
    esac
  done
  
  shift $((OPTIND-1))
  
  local message="$@"
  
  if [[ -n "$text_color" ]]; then
    message="$(text_color_code -e $escape $text_color)${message}$(clear_color -e $escape)"
  fi
  if [[ -n "$background_color" ]]; then
    message="$(background_color_code -e $escape $background_color)${message}$(clear_color -e $escape)"
  fi
  
  echo -n "$message"
}