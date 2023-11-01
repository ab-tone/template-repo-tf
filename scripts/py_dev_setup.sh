#!/bin/bash

if [[ ! -d "./.git" ]]; then echo "this script must be run from the repository root"; return 1; fi

function venv_activate() {
  venv_path=".venv"
  . ./$venv_path/bin/activate
}

function do_py_dev_setup() {
  local -r do_install="$1"
  venv_path=".venv"
  python3 -m venv ./$venv_path
  . ./$venv_path/bin/activate
  python3 -m pip install pip-tools
  if [[ "$do_install" != "0" ]]; then
    python3 -m pip install -r ./requirements/dev-requirements.txt
  fi
}

do_py_dev_setup "$1"
ret=$?; if [[ $ret -ne 0 ]]; then return $ret; fi
