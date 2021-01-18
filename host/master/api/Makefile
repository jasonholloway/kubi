# Module api

_key:=$(out)/api.key
_csrConf:=$(out)/api.csr.conf
_csr:=$(out)/api.csr
_crt:=$(out)/api.crt

$(_key):
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048


define _csrConfData
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[dn]
O=system:masters
CN=kubi

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = kubi
DNS.2 = kubi.local
DNS.3 = puce
DNS.4 = puce.upis
endef

$(_csrConf): $(me)
	mkdir -p $(@D)
	$(file > $@,$(_csrConfData))

$(_csr): $(_key) $(_csrConf)
	openssl req -new -nodes \
		-key $(_key) \
		-config $(_csrConf) \
		-out $@

preps += $(_csr)
files += $(_crt)
keyFiles += $(_key)


$(eval $(call k8sBins_download,kube-apiserver,_bin))


_service:=$(out)/systemd/kube-api.service
encryptionYamlFile:=$(abspath out/etc/encryption.yaml)

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
	--audit-log-path=$(abspath run/audit.log) \
	--bind-address=0.0.0.0 \
	--client-ca-file=$(ca_crt) \
	--enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
	--etcd-cafile=$(ca_crt) \
	--etcd-certfile=$(_crt) \
	--etcd-keyfile=$(_key) \
	--etcd-servers=https://kubi:2379 \
	--event-ttl=1h \
	--encryption-provider-config=$(encryptionYamlFile) \
	--kubelet-certificate-authority=$(ca_crt) \
	--kubelet-client-certificate=$(_crt) \
	--kubelet-client-key=$(_key) \
	--kubelet-https=true \
	--runtime-config='api/all=true' \
	--service-account-key-file=$(controller_crt) \
	--service-cluster-ip-range=10.32.0.0/24 \
	--service-node-port-range=30000-32767 \
	--tls-cert-file=$(_crt) \
	--tls-private-key-file=$(_key) \
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
