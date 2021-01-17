#Module kubelet

_service:=$(out)/systemd/kubelet.service
_config:=$(out)/kubelet.yaml
_kubeconfig:=$(out)/kubelet.kubeconfig
_bin:=$(k8sWorker_binPath)/kubelet

_cluster:=kubi
_user:=system:node:$(host)

define _configData
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: true
  webhook:
    enabled: true
  x509:
    clientCAFile: $(ca_crt)
authorization:
  mode: AlwaysAllow
clusterDomain: "kubi.local"
clusterDNS:
  - "10.32.0.10"
podCIDR: $(cni_podCidr)
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: $(host_crt)
tlsPrivateKeyFile: $(host_key)
endef

$(_config): $(me) $(ca_crt) $(host_crt) $(host_key)
	$(file >$@,$(_configData))


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


define _serviceData
[Unit]
Description=Kubernetes Kubelet
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=$(_bin) \
	--hostname-override=$(host) \
	--config=$(_config) \
	--container-runtime=remote \
	--container-runtime-endpoint=unix://$(containerd_sock) \
	--image-pull-progress-deadline=1m \
	--kubeconfig=$(_kubeconfig) \
	--network-plugin=cni \
	--register-node=true \
	--fail-swap-on=false \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef

$(_service): $(me) $(_bin) $(_config) $(_kubeconfig)
	$(file >$@,$(_serviceData))



services += kubelet
serviceFiles += $(_service)
files += $(_config) $(_kubeconfig) $(_service)
