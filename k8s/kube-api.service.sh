#!/bin/bash

host=${host:?host not set}
INTERNAL_IP=127.0.0.1
name=kube-api
  # --advertise-address=${INTERNAL_IP} \

cat <<EOF | sudo tee /etc/systemd/system/${name}.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/kubi/bin/kube-apiserver \
  --authorization-mode=Node,RBAC \
  --allow-privileged=true \
  --apiserver-count=1 \
  --audit-log-maxage=30 \
  --audit-log-maxbackup=3 \
  --audit-log-maxsize=100 \
  --audit-log-path=/var/log/audit.log \
  --bind-address=0.0.0.0 \
  --client-ca-file=/kubi/ca/crt \
  --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
  --etcd-cafile=/kubi/ca/crt \
  --etcd-certfile=/kubi/api/crt \
  --etcd-keyfile=/kubi/api/key \
  --etcd-servers=https://kubi:2379 \
  --event-ttl=1h \
  --encryption-provider-config=/kubi/k8s/encryption.yaml \
  --kubelet-certificate-authority=/kubi/ca/crt \
  --kubelet-client-certificate=/kubi/api/crt \
  --kubelet-client-key=/kubi/api/key \
  --kubelet-https=true \
  --runtime-config='api/all=true' \
  --service-account-key-file=/kubi/api/key \
  --service-cluster-ip-range=10.32.0.0/24 \
  --service-node-port-range=30000-32767 \
  --tls-cert-file=/kubi/api/crt \
  --tls-private-key-file=/kubi/api/key \
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
