#!/bin/bash

caCrtFile=$(realpath "$1")
hostCrtFile=$(realpath "$2")
hostKeyFile=$(realpath "$3")
podCidr=$4


cat <<EOF
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
	anonymous:
		enabled: true
	webhook:
		enabled: true
	x509:
		clientCAFile: ${caCrtFile}
authorization:
	mode: AlwaysAllow
clusterDomain: "kubi.local"
clusterDNS:
	- "10.32.0.10"
podCIDR: ${podCidr}
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: ${hostCrtFile}
tlsPrivateKeyFile: ${hostKeyFile}

EOF
