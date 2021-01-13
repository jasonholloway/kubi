mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
serviceName:=kube-api
serviceFile:=$(out)/systemd/$(serviceName).service

encryptionYamlFile:=out/etc/encryption.yaml

# note below removed for some reason

internalIp:=127.0.0.1
# --advertise-address=$(internalIp)

define apiServiceConf
[Unit]
Description=Kubernetes API Server

[Service]
ExecStart=$(abspath $(apiBin)) \
	--authorization-mode=Node,RBAC \
	--allow-privileged=true \
	--apiserver-count=1 \
	--audit-log-maxage=30 \
	--audit-log-maxbackup=3 \
	--audit-log-maxsize=100 \
	--audit-log-path=/var/kubi/log/audit.log \
	--bind-address=0.0.0.0 \
	--client-ca-file=$(abspath $(caCrtFile)) \
	--enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
	--etcd-cafile=$(abspath $(caCrtFile)) \
	--etcd-certfile=$(abspath $(apiCrtFile)) \
	--etcd-keyfile=$(abspath $(apiKeyFile)) \
	--etcd-servers=https://kubi:2379 \
	--event-ttl=1h \
	--encryption-provider-config=$(abspath $(encryptionYamlFile)) \
	--kubelet-certificate-authority=$(abspath $(caCrtFile)) \
	--kubelet-client-certificate=$(abspath $(apiCrtFile)) \
	--kubelet-client-key=$(abspath $(apiKeyFile)) \
	--kubelet-https=true \
	--runtime-config='api/all=true' \
	--service-account-key-file=$(abspath $(apiKeyFile)) \
	--service-cluster-ip-range=10.32.0.0/24 \
	--service-node-port-range=30000-32767 \
	--tls-cert-file=$(abspath $(apiCrtFile)) \
	--tls-private-key-file=$(abspath $(apiKeyFile)) \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef


define module

$(serviceFile): $(servicePath)/ $(apiBin) out/etc/encryption.yaml
	$$(file > $$@,$$(apiServiceConf))

services += $(serviceName)
serviceFiles += $(serviceFile)
files += $(serviceFile)

endef

$(eval $(module))
