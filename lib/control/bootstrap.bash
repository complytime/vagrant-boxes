#!/usr/bin/env bash

source "$(dirname ${BASH_SOURCE[0]})/../utils/eval-file.bash"
add_directory_to_load_path "$(dirname ${BASH_SOURCE[0]})/../utils"

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

  rename_terminal
  complete_load
  function__execute_if_exists 'after_bootstrap'
}

function complete_load() {
  export PROJECT_LOADED=true
}

bootstrap
