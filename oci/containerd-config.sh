#!/bin/bash

mkdir -p etc/containerd

cat << EOF | sudo tee etc/containerd/config.toml
[plugins.cri.containerd]
  snapshotter = "overlayfs"
  [plugins.cri.containerd.default_runtime]
    runtime_type = "io.containerd.runtime.v1.linux"
    runtime_engine = "/kubi/bin/runc"
    runtime_root = ""
[plugins.cri.cni]
  bin_dir = "/kubi/opt/cni/bin"
  conf_dir = "/kubi/etc/cni/net.d"
EOF
