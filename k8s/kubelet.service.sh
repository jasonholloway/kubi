#!/bin/bash

host=${host:?host not set}
name=kubelet

cat <<EOF | sudo tee /etc/systemd/system/${name}.service

[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/kubi/bin/kubelet \
  --hostname-override=${host} \
  --config=/kubi/var/kubelet.yaml \
  --container-runtime=remote \
  --container-runtime-endpoint=unix://var/run/containerd/containerd.sock \
  --image-pull-progress-deadline=2m \
  --kubeconfig=/kubi/var/kubelet.kubeconfig \
  --network-plugin=cni \
  --register-node=true \
  --fail-swap-on=false \
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl stop ${name}
sudo systemctl disable ${name}
sudo systemctl daemon-reload
sudo systemctl enable ${name}
sudo systemctl start ${name}
