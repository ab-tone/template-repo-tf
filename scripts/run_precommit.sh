#!/bin/bash

if [[ ! -d "./.git" ]]; then echo "this script must be run from the repository root"; return 1; fi

function _do_run_precommit() {
  # latest on 2023-11-05
  local -r TAG="v1.83.5"; local -r img="ghcr.io/antonbabenko/pre-commit-terraform:$TAG"

  local OPTIND args
  local stage
  while getopts "f" args; do
    case $args in
      f) stage="pre-push";; # do the full set of pre-push checks
      \?) echo "ERROR: invalid option - $args: $OPTARG" >&2; return 1;;
    esac
  done
  if [[ -z "$stage" ]]; then echo -e "INFO: running as pre-commit hook.\n  Use -f to run hooks registered with pre-push stage\n"; fi
  shift $((OPTIND-1))

  local -r pcpath=".pre-commit"
  local -r pccpath=".pre-commit-cache"
  local -r tfcpath=".tflint.d/plugins"
  local -r wrk_dir="/lint"
  local -r config=".pre-commit-config.yaml"
  mkdir -p $(pwd)/$pcpath/$pccpath
  mkdir -p $(pwd)/$pcpath/$tfcpath

  local args=(run --config=$config ${stage:+--hook-stage=pre-push} -a "$@")

  docker run \
    --rm \
    -e "USERID=$(id -u):$(id -g)" \
    -e "GITHUB_TOKEN=$GITHUB_TOKEN_API" \
    -e "TFLINT_PLUGIN_DIR=/$pcpath/$tfcpath" \
    -e "PRE_COMMIT_HOME=/$pcpath/$pccpath" \
    -v $(pwd)/$pcpath:/$pcpath \
    -v $(pwd):$wrk_dir -w $wrk_dir \
    $img \
    "${args[@]}"
  local -r ret=$?; return $ret
}

find . \( -iname ".terraform.lock.hcl" \) -print0 | \
  xargs -0 dirname | \
  xargs -I {} sh -c 'echo "run tf init in {}"; terraform -chdir="{}" init'

_do_run_precommit "$@"
ret=$?; return $ret
