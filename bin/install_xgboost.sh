#!/usr/bin/env bash

set -e
set -xv

target="$(dirname $0)/../vendor/xgboost"
mkdir -p "$target"
target=$(cd "$target"; pwd -P)
cd "$target"

if [ ! -d ".git" ]; then
  git clone --recursive --jobs 4 --depth 1 https://github.com/dmlc/xgboost .
  git submodule update --remote
else
  cd "$target"
fi

if [[ "$OSTYPE" == darwin* ]]; then
  cp make/minimum.mk config.mk
fi

make -j 4

if [[ "$OSTYPE" == darwin* ]] ; then
  install_name_tool -id "$target/lib/libxgboost.dylib" lib/libxgboost.dylib
fi
