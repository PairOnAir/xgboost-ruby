#!/usr/bin/env bash

set -e
set -xv

if ls /usr/local/lib/libxgboost.* > /dev/null 2>&1; then
  echo Shared library already installed in /usr/local/lib
  exit
fi

target="$(dirname $0)/../vendor/xgboost"
mkdir -p "$target"
target=$(cd "$target"; pwd -P)
cd "$target"

if [ ! -d ".git" ]; then
  git clone --recursive --jobs 4 --depth 1 https://github.com/dmlc/xgboost .
fi

git pull
git submodule update --remote

if [[ "$OSTYPE" == darwin* ]]; then
  cp make/minimum.mk config.mk
fi

make --jobs 4

if [ -f lib/libxgboost.so ]; then
  ext=so
elif [ -f lib/libxgboost.dylib ]; then
  ext=dylib
fi

if [ -n "$ext" ]; then
  ln -s "$target/lib/libxgboost.$ext" /usr/local/lib
else
  echo "Didn't find any shared library in $target/lib to symlink into /usr/local/lib"
fi
