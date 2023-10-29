#!/bin/sh
# recursively finds, with prune, any root modules, and executes terraform fmt
find . -type d \( -name .git -prune \) -o \( -exec test -f {}/main.tf \; -print -prune \) | xargs -I{} sh -c 'cd "{}" && pwd && terraform fmt'
