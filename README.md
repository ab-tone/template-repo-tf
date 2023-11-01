# Setting up your dev env

## pre-commit

pre-commit can be run using python in a venv, or using docker as we
use the antonbabenko/pre-commit-terraform hooks, which have a docker image.

docker is preferred as it installs less globally, and there is a pre-commit hook included
in this repo that uses docker

Versioning is not great with either method, so it means that we don't have a deterministic
pre-commit outcome for a given repository sha. Python requires more dependencies to be
installed. See https://github.com/antonbabenko/pre-commit-terraform#1-install-dependencies,
but be aware that this is therefore not a self-contained approach as it uses global installs.

### docker

- Use `. ./scripts/run_precommit.sh` to run manually; or
- `cp ./scripts/pre-commit ./.git/hooks` to run as a pre commit hook

### python

If you don't have it installed, you can use the following instructions

After checking out this repo, ensure you have python 3 installed

```
python3 --version
```

Now from inside the root of the repository directory, run

```
# rm -rf -venv # <-- run this to reset any pre-existing venv if you need
. ./scripts/py_dev_setup.sh
```

## other python deps

Dev-time requirements are listed in `requirements\dev-requirements.in`. This is the file
that should be updated if you need to add a dependency.

`.ver.txt` files are just human-readable summaries, but actual installation
happens from the `*requirements.txt` files, which use versions and hashes to pin dependencies.

To add new dev-time dependencies, add them to requirements.in and then run

```
. ./scripts/py_reqs_refresh.sh
```
