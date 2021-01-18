# Module controller

_key:=$(out)/controller.key
_csr:=$(out)/controller.csr
_crt:=$(out)/controller.crt

$(_key):
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048

$(_csr): $(_key)
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-controller-manager/CN=system:kube-controller-manager" \
		-key $(_key) \
		-out $@


preps += $(_csr)
files += $(_crt) $(_csr)
keyFiles += $(_key)


_serviceName:=kube-controller
_service:=$(out)/systemd/$(_serviceName).service
_kubeconfig:=$(out)/etc/controller.kubeconfig


$(eval $(call k8sBins_download,kube-controller-manager,_bin))


_cluster:=kubi
_user:=system:kube-controller-manager

define _serviceData
[Unit]
Description=Kubernetes Controller Manager

[Service]
ExecStart=$(_bin) \
	--bind-address=0.0.0.0 \
	--cluster-cidr=10.200.0.0/16 \
	--service-cluster-ip-range=10.32.0.0/24 \
	--cluster-name=kubi \
	--cluster-signing-cert-file=$(_crt) \
	--cluster-signing-key-file=$(_key) \
	--kubeconfig=$(_kubeconfig) \
	--leader-elect=true \
	--root-ca-file=$(ca_crt) \
	--service-account-private-key-file=$(_key) \
	--use-service-account-credentials=true \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef

$(_kubeconfig): $(kubectl_bin)
	kubectl config set-cluster $(_cluster) \
		--certificate-authority=$(abspath $(ca_crt)) \
		--embed-certs=true \
		--server=https://kubi:6443 \
		--kubeconfig=$@
	kubectl config set-credentials $(_user)\
		--client-certificate=$(abspath $(_crt)) \
		--client-key=$(abspath $(_key)) \
		--embed-certs=true \
		--kubeconfig=$@
	kubectl config set-context default \
		--cluster=$(_cluster) \
		--user=$(_user) \
		--kubeconfig=$@
	kubectl config use-context default \
		--kubeconfig=$@


$(_service): $(servicePath)/ $(me) $(_bin) $(_kubeconfig)
	$(file > $@,$(_serviceData))


services += $(_serviceName)
serviceFiles += $(_service)
files += $(_service) $(_kubeconfig)
