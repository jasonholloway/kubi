#!/bin/bash
set -e

v=0.8.6
name=cni-plugins-linux-amd64-v$v
url=https://github.com/containernetworking/plugins/releases/download/v${v}/${name}.tgz
tmp=$(mktemp -d)

pushd $tmp

wget $url
tar xzf ${name}.tgz && rm ${name}.tgz
chmod +x ./*
touch ./*

popd

mkdir -p opt/cni/bin \
  && mv $tmp/* opt/cni/bin/

rm -rf $tmp

