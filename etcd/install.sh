#!/bin/bash
set -e

v=$(<etcd/version)
name=etcd-v${v}-linux-amd64
url=https://github.com/etcd-io/etcd/releases/download/v${v}/${name}.tar.gz
tmp=$(mktemp -d)

pushd $tmp

wget -qO- $url \
  | tar xvz $name/etcd $name/etcdctl
chmod +x etcd*/*
touch etcd*/*

popd

mkdir -p bin \
  && mv $tmp/etcd*/* bin/

