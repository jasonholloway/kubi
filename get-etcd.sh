#!/bin/bash

v="$(<etcdVersion)"
name=etcd-v${v}-linux-amd64
url=https://github.com/etcd-io/etcd/releases/download/v${v}/${name}.tar.gz
tmp=$(mktemp -d)

cd $tmp

wget -qO- $url \
  | tar xvz $name/etcd $name/etcdctl
chmod +x etcd*/*
touch etcd*/*

mv etcd*/* /usr/local/bin/

