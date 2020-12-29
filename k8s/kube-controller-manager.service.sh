#!/bin/bash

host=${host:?host not set}
name=kube-controller-manager

cat <<EOF | sudo tee /etc/systemd/system/${name}.service

[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/kubi/bin/kube-controller-manager \
  --bind-address=0.0.0.0 \
  --cluster-cidr=10.200.0.0/16 \
  --service-cluster-ip-range=10.32.0.0/24 \
  --cluster-name=kubi \
  --cluster-signing-cert-file=/kubi/api/crt \
  --cluster-signing-key-file=/kubi/api/key \
  --kubeconfig=/kubi/var/kube-controller-manager.kubeconfig \
  --leader-elect=true \
  --root-ca-file=/kubi/ca/crt \
  --service-account-private-key-file=/kubi/api/key \
  --use-service-account-credentials=true \
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
