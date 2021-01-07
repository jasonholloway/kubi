mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
apiServiceFile:=/etc/systemd/system/kube-api.service

# note below removed for some reason
# --advertise-address=$(internalIp)

define apiService
[Unit]
Description=Kubernetes API Server

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
endef

$(apiServiceFile): $(apiBin) k8s/encryption.yaml $(mkFile)
	$(file > $@,$(apiService))


services += api
files += $(apiServiceFile)
