#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/colors.bash"

function rename_terminal(){
  echo -n -e "\033]0;${PROJECT_NAME}${DELIMITER}${ORGANIZATION_NAME}\007"
}

rename_terminal

function prompt(){
  local divider=")>"
  local prompt_parts=()

  #if [[ "$OS_NAME" == 'Windows' ]]; then
    prompt_parts+=("[$(date "+%H:%M:%S")]")
  #fi

  prompt_parts+=("$PROJECT_NAME")
  prompt_parts+=("$WORKSPACE_SETTING")

  #if [[ "$OS_NAME" == 'Windows' ]]; then
    local display_directory='~'
    if [[ "${HOME}" != "$PWD" ]]; then
      local current_directory="$(basename $PWD)"
      local parent_directory="$(basename $(dirname $PWD))"

      display_directory="$parent_directory/$current_directory"
    fi

    prompt_parts+=("$display_directory")
  #fi

  local color_gradient=(19 20 21 25 26 27 33 39)

  local prompt_text=''

  local count=-1
  for prompt_part in "${prompt_parts[@]}"; do
    if [[ "$OS_NAME" != 'Windows' ]]; then
      count="$((count+1))"
      prompt_text="${prompt_text}$(colorize -e true -t ${color_gradient[$count]} "$prompt_part")"

      count="$((count+1))"
      prompt_text="${prompt_text}$(colorize -e true -t ${color_gradient[$count]} "$divider")"
    else
      prompt_text="${prompt_text}${prompt_part}${divider}"
    fi
  done

  export PS1="$prompt_text "
}

export PROMPT_COMMAND="prompt"
