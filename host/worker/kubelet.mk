serviceFile:=/etc/systemd/system/kubelet.service
configFile:=out/etc/kubelet.yaml
kubeconfigFile:=out/etc/kubelet.kubeconfig



podCidr:="127.64.0.0/16"

define k8sConfig
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
	anonymous:
		enabled: true
	webhook:
		enabled: true
	x509:
		clientCAFile: $(abspath $(caCrtFile))
authorization:
	mode: AlwaysAllow
clusterDomain: "kubi.local"
clusterDNS:
	- "10.32.0.10"
podCIDR: $(podCidr)
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/kubi/nodes/$(host)/crt"
tlsPrivateKeyFile: "/kubi/nodes/$(host)/key"
endef

$(configFile): 
	$(file > $@,$(k8sConfig))



cluster:=kubi
user:=system:node:$(host)

$(kubeconfigFile): k8s/kubelet.kubeconfig.sh
	kubectl config set-cluster $(cluster) \
		--certificate-authority=$(abspath $(caCrtFile)) \
		--embed-certs=true \
		--server=https://$(cluster):6443 \
		--kubeconfig=$@
	kubectl config set-credentials $(user) \
		--client-certificate=/kubi/nodes/$(host)/crt \
		--client-key=/kubi/nodes/${host}/key \
		--embed-certs=true \
		--kubeconfig=$@
	kubectl config set-context default \
		--cluster=$(cluster) \
		--user=$(user) \
		--kubeconfig=$@
	kubectl config use-context default \
		--kubeconfig=$@



define serviceConf
[Unit]
Description=Kubernetes Kubelet
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=$(abspath $(kubeletBin)) \
	--hostname-override=$(host) \
	--config=$(abspath $(configFile)) \
	--container-runtime=remote \
	--container-runtime-endpoint=unix://var/run/containerd/containerd.sock \
	--image-pull-progress-deadline=2m \
	--kubeconfig=$(abspath $(kubeconfigFile)) \
	--network-plugin=cni \
	--register-node=true \
	--fail-swap-on=false \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef

$(serviceFile): $(kubeletBin) $(configFile) $(kubeconfigFile)
	$(file > $@,$(serviceConf))


services += kubelet
files += $(serviceFile) $(configFile) $(kubeconfigFile)
