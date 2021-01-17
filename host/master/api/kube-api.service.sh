#!/bin/bash

apiBinFile=$(realpath "$1")
caCrtFile=$(realpath "$2")
crtFile=$(realpath "$3")
keyFile=$(realpath "$4")
encryptionFile=$(realpath "$5")

cat <<EOF
[Unit]
Description=Kubernetes API Server

[Service]
ExecStart=${apiBinFile} \
	--authorization-mode=Node,RBAC \
	--allow-privileged=true \
	--apiserver-count=1 \
	--audit-log-maxage=30 \
	--audit-log-maxbackup=3 \
	--audit-log-maxsize=100 \
	--audit-log-path=/var/kubi/log/audit.log \
	--bind-address=0.0.0.0 \
	--client-ca-file=${caCrtFile} \
	--enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
	--etcd-cafile=${caCrtFile} \
	--etcd-certfile=${crtFile} \
	--etcd-keyfile=${keyFile} \
	--etcd-servers=https://kubi:2379 \
	--event-ttl=1h \
	--encryption-provider-config=${encryptionFile} \
	--kubelet-certificate-authority=${caCrtFile} \
	--kubelet-client-certificate=${crtFile} \
	--kubelet-client-key=${keyFile} \
	--kubelet-https=true \
	--runtime-config='api/all=true' \
	--service-account-key-file=${keyFile} \
	--service-cluster-ip-range=10.32.0.0/24 \
	--service-node-port-range=30000-32767 \
	--tls-cert-file=${crtFile} \
	--tls-private-key-file=${keyFile} \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
