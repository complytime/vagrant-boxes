#!/usr/bin/env bash

function sudo__execute_with_administrator_privileges() {
  export cmd=${*}
  export preserve_home=$HOME
  export preserve_rubyopt=$RUBYOPT
  export preserve_path=$PATH

  debug "sudo__execute_with_administrator_privileges(${*})"

  sudo -E bash <<-'ENDCOMMANDS'
    export HOME=$preserve_home
    export LOGNAME=$SUDO_USER
    export USER=$SUDO_USER
    export USERNAME=$SUDO_USER
    export RUBYOPT=$preserve_rubyopt
    export PATH=$preserve_path

    eval $cmd
ENDCOMMANDS

  local sudo_exit_code=$?

  unset preserve_home
  unset cmd

  return $sudo_exit_code
}

function sudo__execute_with_administrator_privileges_f() {
  sudo__execute_with_administrator_privileges ${*}
  fail_if "command failed: ${*}"
}

if [[ "$OS_NAME" == 'Windows' ]]; then
  function sudo(){
    local command="$@"

    if [[ "$command" =~ -E ]]; then
      command=''
    fi

    if [[ -z "$command" && ! -t 0 ]]; then
      local IFS=
      local data=''
      while read data ; do
        command="$command
$data"
      done
    fi

    command="
export SUDO_USER=$USER
$command"
#read -p 'Press [Enter] key to exit...'"

    debug "$command"
    # maybe use: https://sourceforge.net/p/manufacture/wiki/syswin-su/
    #cygstart -v -w --action=runas bash --login -i -c "\"$command"\"
    eval "$command"
  }
fi
