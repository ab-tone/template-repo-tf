#!/bin/bash

function do_apply() {
  local OPTIND arg ans hasopts
  local project_id remove_previous skip_init no_ask speed_run

  while getopts "hp:ragf" arg; do
    hasopts=1
    echo "'$arg': '$OPTARG'"
    case $arg in
      h) unset hasopts; break;;

      p) project_id="${OPTARG}";; # specify the project to use
      r) remove_previous="1";; # set to 1 remove the existing network with the name 'default'

      a) no_ask="1";; # -a to suppress asking for inputs
      g) skip_init="1";; # just go: set to skip the terraform init
      f) speed_run="1";; # just do, don't ask to show things or do apply
      \?) echo "invalid option -$OPTARG" >&2; unset hasopts; break;;
    esac
  done
  if [[ -z "$hasopts" ]]; then
    cat <<EOF
-h               Show this help text
  no switches

Operational params
-p               Set the project_id. If not set, then takes the value from the global \$proj_id env var
-r               Specify this to remove the previous default network

Automation and speed-up
-a               no-ask. Only error if inputs not given, don\'t ask interactively.
-g               no-tf-init. Skip running terraform init, e.g. if you know you already did it
-s               speed-run. Don't stop and ask to show plan output, just plan and apply
EOF
  fi

  if [[ -z $no_ask ]]; then
    if [[ -z "${project_id:-$proj_id}" ]]; then read "-p not set, and \$proj_id not set. Enter project id: " project_id; fi
  else
    if [[ -z "${project_id:-$proj_id}" ]]; then echo "ERROR: neither -p nor proj_id given"; return 1; fi
  fi

  echo "skip terraform init: '${skip_init:-0}'"
  # use the environment proj_id by default
  project_id=${project_id:-$proj_id}; echo "project_id: '$project_id'"
  ans="$remove_previous"
  if [[ "$ans" -eq 1 ]]; then unset remove_previous; else remove_previous="false"; fi
  echo "remove default network: '${remove_previous:-"true"}'"

  if [[ -z "$skip_init" ]]; then terraform init; fi

  terraform plan -var="project_id=$project_id" \
    ${remove_previous:+-var="remove_previous=$remove_previous"} \
    -out tfplan > tfplan.stdout.txt
  ret=$?; if [[ "$ret" -ne 0 ]]; then echo "ERROR: tf plan failed: $ret" >&2; return $?; fi

  terraform show tfplan > tfplan.asci
  ret=$?; if [[ "$ret" -ne 0 ]]; then echo "ERROR: tf show to asci failed: $ret" >&2; return $?; fi
  terraform show tfplan -no-color > tfplan.txt
  ret=$?; if [[ "$ret" -ne 0 ]]; then echo "ERROR: tf show to txt failed: $ret" >&2; return $?; fi

  if [[ -z "$speed_run" ]]; then
    read -p "Plan complete, page through plan stdout? (Y/n/x): " ans
    if [[ "${ans:-y}" =~ ^[xX]$ ]]; then return 0; fi
    if [[ "${ans:-y}" =~ ^[yY]$ ]]; then less -R tfplan.stdout.txt; fi

    read -p "Page through plan? (Y/n/x): " ans
    if [[ "${ans:-y}" =~ ^[xX]$ ]]; then return 0; fi
    if [[ "${ans:-y}" =~ ^[yY]$ ]]; then less -R tfplan.asci; fi
  fi

  if [[ -z "$speed_run" ]]; then
    read -p "Press enter to do the apply? (Y/n/x): " ans
    if [[ "${ans:-y}" =~ ^[xX]$ ]]; then return 0; fi
  else
    ans="y"
  fi

  if [[ "${ans:-y}" =~ ^[yY]$ ]]; then
    terraform apply tfplan
    ret=$?; if [[ "$ret" -ne 0 ]]; then echo "ERROR: tf apply failed: $ret" >&2; return $?; fi
  fi
}

do_apply "$@"
return $?
