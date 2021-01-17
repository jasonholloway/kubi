# Module api

_d:=$(dir $(me))

_serviceTemplate:=$(_d)/kube-api.service.sh
_service:=$(out)/systemd/kube-api.service

encryptionYamlFile:=out/etc/encryption.yaml

# internalIp:=127.0.0.1
# --advertise-address=$(internalIp)

define _serviceData
[Unit]
Description=Kubernetes API Server

[Service]
ExecStart=$(abspath $(_bin)) \
	--authorization-mode=Node,RBAC \
	--allow-privileged=true \
	--apiserver-count=1 \
	--audit-log-maxage=30 \
	--audit-log-maxbackup=3 \
	--audit-log-maxsize=100 \
	--audit-log-path=/var/kubi/log/audit.log \
	--bind-address=0.0.0.0 \
	--client-ca-file=$(abspath $(ca_crt)) \
	--enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
	--etcd-cafile=$(abspath $(ca_crt)) \
	--etcd-certfile=$(abspath $(_crt)) \
	--etcd-keyfile=$(abspath $(_key)) \
	--etcd-servers=https://kubi:2379 \
	--event-ttl=1h \
	--encryption-provider-config=$(abspath $(encryptionYamlFile)) \
	--kubelet-certificate-authority=$(abspath $(ca_crt)) \
	--kubelet-client-certificate=$(abspath $(_crt)) \
	--kubelet-client-key=$(abspath $(_key)) \
	--kubelet-https=true \
	--runtime-config='api/all=true' \
	--service-account-key-file=$(abspath $(_key)) \
	--service-cluster-ip-range=10.32.0.0/24 \
	--service-node-port-range=30000-32767 \
	--tls-cert-file=$(abspath $(_crt)) \
	--tls-private-key-file=$(abspath $(_key)) \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef

$(_service): $(me) $(servicePath)/ $(_bin) $(encryptionYamlFile)
	$(file >$@,$(_serviceData))


services += kube-api
serviceFiles += $(_service)
files += $(_service)
