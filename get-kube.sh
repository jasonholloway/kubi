#!/bin/bash +x

v="$(<kubeVersion)"
url=https://storage.googleapis.com/kubernetes-release/release/v${v}/bin/linux/amd64
tmp=$(mktemp -d)

cd $tmp

wget -q --show-progress --https-only --timestamping \
  "$url/kube-apiserver" \
  "$url/kube-controller-manager" \
  "$url/kube-scheduler" \
  "$url/kubectl"

chmod +x *
touch *

mv * /usr/local/bin/

