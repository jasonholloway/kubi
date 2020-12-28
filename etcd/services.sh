#!/bin/bash

host=${host:?host not set}

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd

[Service]
Type=notify
ExecStart=/kubi/bin/etcd \
  --name ${host} \
  --trusted-ca-file=/kubi/ca/crt \
  --peer-trusted-ca-file=/kubi/ca/crt \
  --cert-file=/kubi/api/crt \
  --key-file=/kubi/api/key \
  --peer-cert-file=/kubi/api/crt \
  --peer-key-file=/kubi/api/key \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://127.0.0.1:2380 \
  --listen-peer-urls https://127.0.0.1:2380 \
  --listen-client-urls https://127.0.0.1:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://127.0.0.1:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster ${host}=https://${host}:2380 \
  --initial-cluster-state new \
  --data-dir=/kubi/var/etcd \
  --logger=zap
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

EOF

sudo systemctl stop etcd
sudo systemctl disable etcd
sudo systemctl enable etcd
sudo systemctl daemon-reload
sudo systemctl start etcd
