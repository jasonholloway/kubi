#!/bin/bash

name=containerd

cat <<EOF | sudo tee /etc/systemd/system/${name}.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/kubi/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl stop ${name}
sudo systemctl disable ${name}
sudo systemctl daemon-reload
sudo systemctl enable ${name}
sudo systemctl start ${name}
