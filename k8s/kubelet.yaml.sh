#!/bin/bash

host=${host:?no host specidied}
POD_CIDR=127.64.0.0/16

cat <<EOF | sudo tee var/kubelet.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/kubi/ca/crt"
authorization:
  mode: Webhook
clusterDomain: "kubi.local"
clusterDNS:
  - "10.32.0.10"
podCIDR: "${POD_CIDR}"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/kubi/nodes/${host}/crt"
tlsPrivateKeyFile: "/kubi/nodes/${host}/key"
EOF
