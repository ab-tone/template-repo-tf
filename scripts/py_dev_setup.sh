#!/bin/bash

if [[ ! -d "./.git" ]]; then echo "this script must be run from the repository root"; return 1; fi

venv_path=".venv"
python3 -m venv ./$venv_path
. ./$venv_path/bin/activate
