#!/usr/bin/env bash

export PROJECT_NAME="vagrant-boxes"
source "$(dirname ${BASH_SOURCE[0]})/../utils/eval-file.bash"

export PATHS_PROJECT_LIB_CONTROL="$(absolute_path "$(dirname "${BASH_SOURCE[0]}")")"
export PATHS_PROJECT_LIB="$(dirname "${PATHS_PROJECT_LIB_CONTROL}")"
export PATHS_PROJECT_HOME="$(dirname "${PATHS_PROJECT_LIB}")"
export PATHS_PROJECT_LIB_TOOLS="${PATHS_PROJECT_LIB}/tools"
export PATHS_PROJECT_LIB_UTILS="${PATHS_PROJECT_LIB}/utils"

add_directory_to_load_path "${PATHS_PROJECT_LIB_UTILS}"
add_directory_to_load_path "${PATHS_PROJECT_LIB_TOOLS}"

require 'os'
require 'terminal'

function assert_not_already_loaded() {
	if [[ -n "$PROJECT_LOADED" ]]; then
	  error "
########################################    FAILURE    ##############################################

                    You have already sourced this terminal to a project.
              You cannot source multiple times or from one project to another.
                    The project $PROJECT_NAME has already been sourced.

#####################################################################################################
"
	  return
	fi
}

function bootstrap() {
  assert_not_already_loaded
  function__execute_if_exists 'before_bootstrap'

  local auto_load_bash_source_file_path=''
  for auto_load_bash_source_file_path in `find "${PATHS_PROJECT_LIB_TOOLS}" -type f -iname '*.bash'`; do
  	source "$auto_load_bash_source_file_path"
  done

  rename_terminal
  complete_load
  function__execute_if_exists 'after_bootstrap'
}

function complete_load() {
  export PROJECT_LOADED=true
}

bootstrap

cd "${PATHS_PROJECT_HOME}"