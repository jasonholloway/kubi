#!/bin/bash

host=${host:?host not set}
internalIP=${internalIP:?internalIP not set}

#
# so the kube path needs to be somewhere recognisable
#

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd

[Service]
Type=notify
ExecStart=/kubi/bin/etcd \
  --name ${host} \
  --trusted-ca-file=/kubi/ca/crt \
  --peer-trusted-ca-file=/kubi/ca/crt \
  --cert-file=/kubi/etcd/crt \
  --key-file=/kubi/etcd/key \
  --peer-cert-file=/kubi/etcd/crt \
  --peer-key-file=/kubi/etcd/key \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://$internalIP:2380 \
  --listen-peer-urls https://$internalIP:2380 \
  --listen-client-urls https://$internalIP:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://$internalIP:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster controller-0=https://10.240.0.10:2380,controller-1=https://10.240.0.11:2380,controller-2=https://10.240.0.12:2380 \
  --initial-cluster-state new \
  --data-dir=/kubi/var/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

EOF
