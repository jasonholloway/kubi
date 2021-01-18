# Module proxy

_key:=$(out)/proxy.key
_csr:=$(out)/proxy.csr
_crt:=$(out)/proxy.crt
_user:=system:kube-proxy
_group:=system:node-proxier

$(_key):
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048

$(_csr): $(_key)
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=$(_group)/CN=$(_user)" \
		-key $(_key) \
		-out $@

preps += $(_csr)
files += $(_crt) $(_csr)
keyFiles += $(_key)


_service:=$(out)/systemd/kube-proxy.service
_config:=$(out)/proxy.yaml
_kubeconfig:=$(out)/proxy.kubeconfig


$(eval $(call k8sBins_download,kube-proxy,_bin))


define _configData
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: $(_kubeconfig)
mode: iptables
clusterCIDR: "127.64.0.0/16"
endef

$(_config): $(me) $(_kubeconfig)
	$(file >$@,$(_configData))


_cluster:=kubi

$(_kubeconfig): $(kubectl_bin) $(ca_crt) $(host_crt) $(host_key)
	kubectl config set-cluster $(_cluster) \
		--certificate-authority=$(ca_crt) \
		--embed-certs=true \
		--server=https://$(_cluster):6443 \
		--kubeconfig=$@
	kubectl config set-credentials $(_user) \
		--client-certificate=$(_crt) \
		--client-key=$(_key) \
		--embed-certs=true \
		--kubeconfig=$@
	kubectl config set-context default \
		--cluster=$(_cluster) \
		--user=$(_user) \
		--kubeconfig=$@
	kubectl config use-context default \
		--kubeconfig=$@


define _serviceData
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=$(_bin) --config=$(_config)
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef

$(_service): $(me) $(_bin) $(_config)
	$(file >$@,$(_serviceData))


services += kube-proxy
serviceFiles += $(_service)
files += $(_config) $(_kubeconfig) $(_service)
