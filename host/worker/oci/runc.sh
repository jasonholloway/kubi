#!/bin/bash
set -e

v=1.0.0-rc91
name=runc.amd64
url=https://github.com/opencontainers/runc/releases/download/v${v}/${name}
tmp=$(mktemp -d)

pushd $tmp

wget $url
chmod +x $name
touch $name

popd

mkdir -p bin \
  && mv $tmp/$name bin/runc

