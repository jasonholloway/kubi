#!/bin/bash

host=$1
binFile=$(realpath "$2")
caCrtFile=$(realpath "$3")
crtFile=$(realpath "$4")
keyFile=$(realpath "$5")
dataDir=$(realpath "$6")

cat <<EOF
[Unit]
Description=etcd

[Service]
Type=notify
ExecStart=${binFile} \
	--name ${host} \
	--trusted-ca-file=${caCrtFile} \
	--peer-trusted-ca-file=${caCrtFile} \
	--cert-file=${crtFile} \
	--key-file=${keyFile} \
	--peer-cert-file=${crtFile} \
	--peer-key-file=${keyFile} \
	--peer-client-cert-auth \
	--client-cert-auth \
	--initial-advertise-peer-urls https://127.0.0.1:2380 \
	--listen-peer-urls https://127.0.0.1:2380 \
	--listen-client-urls https://127.0.0.1:2379,https://127.0.0.1:2379 \
	--advertise-client-urls https://127.0.0.1:2379 \
	--initial-cluster-token etcd-cluster-0 \
	--initial-cluster ${host}=https://127.0.0.1:2380 \
	--initial-cluster-state new \
	--data-dir=${dataDir} \
	--logger=zap
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
