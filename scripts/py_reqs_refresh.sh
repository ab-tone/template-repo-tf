#!/bin/bash

if [[ ! -d "./.git" ]]; then echo "this script must be run from the repository root"; return 1; fi
if [[ -z "$VIRTUAL_ENV" ]]; then echo "this script must be run from inside the venv"; return 1; fi

function _do_py_reqs_refresh() {
  cd requirements
  local fn="$1"
  if [[ -z "$fn" ]]; then echo "ERROR: requirements file prefix not specified"; return 1; fi

  pip install -r $fn.in
  pip-compile --generate-hashes $fn.in
  pip-compile --output-file=$fn.ver.txt $fn.in
  python -m pip install -r $fn.txt
  cd -
}

_do_py_reqs_refresh dev-requirements
ret=$?; if [[ $ret -ne 0 ]]; then return $ret; fi
