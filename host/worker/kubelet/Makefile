#Module kubelet

_d:=$(dir $(lastword $(MAKEFILE_LIST)))
_configTemplate:=$(_d)kubelet.yaml.sh
_serviceTemplate:=$(_d)kubelet.service.sh

_service:=$(out)/systemd/kubelet.service
_config:=$(out)/kubelet.yaml
_kubeconfig:=$(out)/kubelet.kubeconfig

_cluster:=kubi
_user:=system:node:$(host)
_podCidr:="127.64.0.0/16"

$(_config): $(_configTemplate) $(ca_crt) $(host_crt) $(host_key)
	$(_configTemplate) \
		$(ca_crt) \
		$(host_crt) \
		$(host_key) \
		$(_podCidr) > $@

$(_kubeconfig): $(kubectl_bin) $(ca_crt) $(host_crt) $(host_key)
	kubectl config set-cluster $(_cluster) \
		--certificate-authority=$(abspath $(ca_crt)) \
		--embed-certs=true \
		--server=https://$(_cluster):6443 \
		--kubeconfig=$@
	kubectl config set-credentials $(_user) \
		--client-certificate=$(abspath $(host_crt)) \
		--client-key=$(abspath $(host_key)) \
		--embed-certs=true \
		--kubeconfig=$@
	kubectl config set-context default \
		--cluster=$(_cluster) \
		--user=$(_user) \
		--kubeconfig=$@
	kubectl config use-context default \
		--kubeconfig=$@

$(_service): $(_serviceTemplate) $(_bin) $(_config) $(_kubeconfig) $(containerd_sock)
	$(_serviceTemplate) \
		$(_bin) \
		$(host) \
		$(_config) \
		$(_kubeconfig) \
		$(containerd_sock) > $@


services += kubelet
serviceFiles += $(_service)
files += $(_config) $(_kubeconfig) $(_service)
