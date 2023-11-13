#!/bin/bash

function do_apply() {
  local OPTIND arg ans
  local project_id remove_previous skip_init destroy
  local vpc_nm allow_ips

  while getopts "p:n:r:i:gd" arg; do
    echo "'$arg': '$OPTARG'"
    case $arg in
      p) project_id="${OPTARG}";; # specify the project to use
      n) vpc_nm="${OPTARG}";; # the name of the vpc to create
      r) remove_previous="${OPTARG}";; # set to 1 remove the existing network with the name 'default'
      i) allow_ips="${OPTARG}";; # set to the allowed ips for the ssh and rdp rules
      g) skip_init="1";; # just go: set to skip the terraform init
      d) destroy="1";; # set to use -destroy
      \?) echo "invalid option -$OPTARG" >&2; return 1;;
    esac
  done

  echo "skip terraform init: '${skip_init:-0}'"
  if [[ -n "$destroy" ]]; then echo "WARNING: run terraform destroy: '${destroy:-0}'"; fi
  # use the environment proj_id by default
  project_id=${project_id:-$proj_id}; echo "project_id: '$project_id'"
  ans="$remove_previous"
  if [[ "$ans" -eq 1 ]]; then unset remove_previous; else remove_previous="false"; fi
  echo "remove default network: '${remove_previous:-"true"}'"
  echo "default_vpc_nm: '${vpc_nm:-default}'"

  if [[ -z "$skip_init" ]]; then terraform init; fi

  local ip_list
  local i
  for i in ${!allow_ips[@]}; do
    if [[ "$i" -gt 0 ]]; then ip_list+=","; fi
    ip_list+=$(echo "{'name_suffix':'$i','ip_range':'${allow_ips[$i]}'}" | sed 's/'\''/'\"'/g')
  done
  if [[ -n $ip_list ]]; then ip_list="[$ip_list]"; fi

  terraform plan -var="project_id=$project_id" \
    ${vpc_nm:+-var="default_vpc_nm=$vpc_nm"} \
    ${ip_list:+-var="rdp_ssh_source_ranges=$ip_list"} \
    ${remove_previous:+-var="remove_previous=$remove_previous"} \
    ${destroy:+-destroy} \
    -out tfplan > tfplan.stdout.txt
  ret=$?; if [[ "$ret" -ne 0 ]]; then echo "ERROR: tf plan failed: $ret" >&2; return $ret; fi

  terraform show tfplan > tfplan.asci
  ret=$?; if [[ "$ret" -ne 0 ]]; then echo "ERROR: tf show to asci failed: $ret" >&2; return $ret; fi
  terraform show tfplan -no-color > tfplan.txt
  ret=$?; if [[ "$ret" -ne 0 ]]; then echo "ERROR: tf show to txt failed: $ret" >&2; return $ret; fi

  read -p "Plan complete, page through plan stdout? (Y/n/x): " ans
  if [[ "${ans:-y}" =~ ^[xX]$ ]]; then return 0; fi
  if [[ "${ans:-y}" =~ ^[yY]$ ]]; then less -R tfplan.stdout.txt; fi

  read -p "Page through plan? (Y/n/x): " ans
  if [[ "${ans:-y}" =~ ^[xX]$ ]]; then return 0; fi
  if [[ "${ans:-y}" =~ ^[yY]$ ]]; then less -R tfplan.asci; fi

  read -p "Press enter to do the apply? (Y/n/x): " ans
  if [[ "${ans:-y}" =~ ^[xX]$ ]]; then return 0; fi
  if [[ "${ans:-y}" =~ ^[yY]$ ]]; then
    terraform apply tfplan
    ret=$?; if [[ "$ret" -ne 0 ]]; then echo "ERROR: tf apply failed: $ret" >&2; return $ret; fi
  fi
}

do_apply "$@"
return $?
