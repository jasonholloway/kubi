#!/bin/bash

sockFile=$1
debugSockFile=$2

cat <<EOF
[grpc]
	address = "${sockFile}"

[debug]
	address = "${debugSockFile}"

[plugins.cri.containerd]
	snapshotter = "overlayfs"
	[plugins.cri.containerd.default_runtime]
		runtime_type = "io.containerd.runtime.v1.linux"
		runtime_engine = "/kubi/bin/runc"
		runtime_root = ""

[plugins.cri.cni]
	bin_dir = "/kubi/bin/cni"
	conf_dir = "/kubi/etc/cni/net.d"
EOF
