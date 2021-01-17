#!/bin/bash
set -x

kubeletBin=$(realpath "$1")
host=$2
configFile=$(realpath "$3")
kubeconfigFile=$(realpath "$4")
containerdSockFile=$(realpath "$5")

cat <<EOF
[Unit]
Description=Kubernetes Kubelet
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=${kubeletBin} \
	--hostname-override=${host} \
	--config=${configFile} \
	--container-runtime=remote \
	--container-runtime-endpoint=unix:/${containerdSockFile} \
	--image-pull-progress-deadline=2m \
	--kubeconfig=${kubeconfigFile} \
	--network-plugin=cni \
	--register-node=true \
	--fail-swap-on=false \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

EOF
