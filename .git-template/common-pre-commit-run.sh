function _do_run_precommit_hook() {
  # latest on 2023-11-05
  local -r TAG="v1.83.5"; local -r img="ghcr.io/antonbabenko/pre-commit-terraform:$TAG"

  local OPTIND arg
  local hook_nm
  while getopts "h:" arg; do
    case $arg in
      h) hook_nm="$OPTARG";;
      \?) echo "ERROR: invalid option - $args: $OPTARG" >&2; return 1;;
    esac
  done
  if [[ -z "$hook_nm" ]]; then echo "ERROR - hook name not given"; return 1; fi
  shift $((OPTIND-1))

  local -r pcpath=".pre-commit"
  local -r pccpath=".pre-commit-cache"
  local -r tfcpath=".tflint.d/plugins"
  local -r wrk_dir="/lint"
  local -r config=".pre-commit-config.yaml"
  mkdir -p $(pwd)/$pcpath/$pccpath
  mkdir -p $(pwd)/$pcpath/$tfcpath

  local args=(hook-impl --config="$config" --hook-type="$hook_nm" --hook-dir "$wrk_dir" -- "$@")

  local -r input=$(cat)
  echo "$input" | docker run -i \
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

function is_sourced() {
  local sourced
  (
    [[ -n $ZSH_VERSION && $ZSH_EVAL_CONTEXT =~ :file$ ]] ||
    [[ -n $KSH_VERSION && "$(cd -- "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" != "$(cd -- "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ]] ||
    [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)
  ) && sourced=1 || sourced=0
  return sourced
}

_do_run_precommit_hook -h $stage -- "$@"; ret=$?
echo "$stage result: $ret"

if [[ is_sourced -eq 0 ]]; then exit $ret; fi
return $ret;
