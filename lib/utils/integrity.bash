#!/usr/bin/env bash


function get_source_latest(){
  local temp_ruby_bin=$(which ruby)
  fail_if 'not able to find any ruby installation, at least 1.9 is a prerequisite'
	RUBYOPT='' $temp_ruby_bin -e "print File.mtime(Dir.glob('$1/**/*').max_by {|source_file| File.mtime(source_file)})"
  fail_if 'not able to get latest source'
}

function get_file_time(){
  local temp_ruby_bin=$(which ruby)
  fail_if 'not able to find any ruby installation, at least 1.9 is a prerequisite'
  RUBYOPT='' $temp_ruby_bin -e "print File.mtime('$1')"
  fail_if 'not able to get file time'
}

function set_integrity() {
  export BASH_SOURCE_LOCK="$(get_source_latest "${ECOSYSTEM_PATHS_SHELL_HOME}")"
  export BASH_SOURCE_LOCK="$BASH_SOURCE_LOCK$(get_source_latest "${PATHS_PROJECT_WORKSPACE_SETTINGS_SHELL_HOME}")"
  export BASH_SOURCE_LOCK="$BASH_SOURCE_LOCK$(get_file_time "${PATHS_PROJECT_HOME}/.ecosystem")"
  export BASH_SOURCE_LOCK="$BASH_SOURCE_LOCK$(get_source_latest "${PATHS_PROJECT_WORKSPACE_SETTINGS_HOME}/chef")"
}

set_integrity

export VALIDATE_INTEGRITY=true

function assert_set_env_is_up_to_date(){
	if [[ -z "$VALIDATE_INTEGRITY" || $VALIDATE_INTEGRITY == false ]]; then
		return 0
	fi

  export current_bash_source_latest="$(get_source_latest "${ECOSYSTEM_PATHS_SHELL_HOME}")"
  export current_bash_source_latest="$current_bash_source_latest$(get_source_latest "${PATHS_PROJECT_WORKSPACE_SETTINGS_SHELL_HOME}")"
  export current_bash_source_latest="$current_bash_source_latest$(get_file_time "${PATHS_PROJECT_HOME}/.ecosystem")"
  export current_bash_source_latest="$current_bash_source_latest$(get_source_latest "${PATHS_PROJECT_WORKSPACE_SETTINGS_HOME}/chef")"

  if [[ "$current_bash_source_latest" != "$BASH_SOURCE_LOCK" ]]; then
    fail "
######################################################    FAILURE    ##############################################
    The source files that define the workspace for this project have been updated since you last sourced
    your terminal window/tab. Execute the command exit, then type the up arrow to re-execute the command:
    bash --init-file ${PATHS_PROJECT_HOME}/.ecosystem
###################################################################################################################
"
  fi
}
