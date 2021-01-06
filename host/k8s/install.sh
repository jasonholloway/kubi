#!/bin/bash +x

v="$(<k8s/version)"
url="https://storage.googleapis.com/kubernetes-release/release/v${v}/bin/linux/amd64"
tmp="$(mktemp -d)"

pushd "$tmp"

wget -q --show-progress --https-only --timestamping \
  "$url/kube-apiserver" \
  "$url/kube-controller-manager" \
  "$url/kube-scheduler" \
  "$url/kubectl" \
  "$url/kubelet" \
  "$url/kube-proxy"

chmod +x ./*
touch ./*
 
popd
mv $tmp/* bin/

rm -rf "$tmp"
