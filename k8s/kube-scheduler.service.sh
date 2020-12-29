#!/bin/bash

host=${host:?host not set}
name=kube-scheduler

cat <<EOF | sudo tee /etc/systemd/system/${name}.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/kubi/bin/kube-scheduler \
  --config=/kubi/k8s/kube-scheduler.yaml \
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
