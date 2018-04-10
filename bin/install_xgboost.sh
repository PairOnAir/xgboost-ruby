#!/usr/bin/env bash

set -e
set -xv

target="$(dirname $0)/../vendor/xgboost"
mkdir -p "$target"
target=$(cd "$target"; pwd -P)
cd "$target"

if [ ! -d .git ]; then
  git clone --recurse-submodules --jobs 4 https://github.com/dmlc/xgboost .
else
  git fetch --recurse-submodules --jobs 4
fi

if [[ -z "$1" ]]; then
  git checkout origin/master
  git submodule update --remote
else
  git checkout "$1"
fi

if [[ "$OSTYPE" == darwin* ]]; then
  cp make/minimum.mk config.mk
fi

make --jobs 4
