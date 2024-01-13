#!/bin/bash

usage () {
  echo "usage: . nimenv.sh [start | stop]";
}

start () {
  if [ "$INSIDE_NIMENV" == true ]; then {
    echo "already running nimenv";
  } else {
    echo "starting environment";
    export INSIDE_NIMENV=true;
    export OLD_PATH=$PATH;
    export PATH=$PATH:$HOME/.nimble/bin;
    export OLD_PS1=$PS1;
    export PS1="\[\033[1;35m\](nimenv)\[\033[0m\] $PS1";
  } fi
}

stop () {
  if [ "$INSIDE_NIMENV" == true ]; then {
    echo "stopping environment";
    export PS1=$OLD_PS1;
    export PATH=$OLD_PATH;
    unset -v OLD_PS1;
    unset -v INSIDE_NIMENV;
  } fi
}

_complete_nimenv () {
  if [[ 
    ( "${COMP_WORDS[1]}" == "nimenv.sh" ) && 
    ( ( "${COMP_WORDS[2]}" == "start" ) || 
      ( "${COMP_WORDS[2]}" == "stop" ) )
  ]]; then {
    COMPREPLY=();
  } elif [[ ( "$INSIDE_NIMENV" == true ) && ( "${COMP_WORDS[1]}" == "nimenv.sh" ) ]]; then {
    COMPREPLY=("stop");
  } elif [[ ( -z "$INSIDE_NIMENV" ) && ( "${COMP_WORDS[1]}" == "nimenv.sh" ) ]]; then {
    COMPREPLY=("start");
  } else {
    COMPREPLY=($(compgen -A file ${COMP_WORDS[-1]}));
  } fi
  
  return 0;
}

complete -F _complete_nimenv "."

case $BASH_ARGV0 in
  ./*)
  usage;
  exit;
  ;;
esac

case $1 in 
  start)
  start;
  ;;
  stop)
  stop;
  ;;
  *)
  usage;
  ;;
esac

