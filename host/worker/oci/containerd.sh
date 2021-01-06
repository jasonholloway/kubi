#!/bin/bash
set -e

v=1.3.6
name=containerd-$v-linux-amd64
url=https://github.com/containerd/containerd/releases/download/v$v/$name.tar.gz
tmp=$(mktemp -d)

pushd $tmp

wget -qO- $url | tar xz
chmod +x bin/*
touch bin/*

popd

mkdir -p bin \
  && mv $tmp/bin/* bin/

