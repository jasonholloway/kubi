serviceName:=kube-controller
serviceFile:=$(out)/systemd/$(serviceName).service
kubeconfigFile:=out/var/controller.kubeconfig
cluster:=kubi
user:=system:kube-controller-manager

define controllerServiceConf
[Unit]
Description=Kubernetes Controller Manager

[Service]
ExecStart=$(abspath $(controllerBin)) \
	--bind-address=0.0.0.0 \
	--cluster-cidr=10.200.0.0/16 \
	--service-cluster-ip-range=10.32.0.0/24 \
	--cluster-name=kubi \
	--cluster-signing-cert-file=$(abspath $(apiCrtFile)) \
	--cluster-signing-key-file=$(abspath $(apiKeyFile)) \
	--kubeconfig=$(abspath $(kubeconfigFile)) \
	--leader-elect=true \
	--root-ca-file=$(abspath $(caCrtFile)) \
	--service-account-private-key-file=$(abspath $(apiKeyFile)) \
	--use-service-account-credentials=true \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef


define module

$(kubeconfigFile): $(kubectlBin)
	kubectl config set-cluster $(cluster) \
		--certificate-authority=$(abspath $(caCrtFile)) \
		--embed-certs=true \
		--server=https://kubi:6443 \
		--kubeconfig=$$@
	kubectl config set-credentials $(user)\
		--client-certificate=$(abspath $(controllerCrtFile)) \
		--client-key=$(abspath $(controllerKeyFile)) \
		--embed-certs=true \
		--kubeconfig=$$@
	kubectl config set-context default \
		--cluster=$(cluster) \
		--user=$(user) \
		--kubeconfig=$$@
	kubectl config use-context default \
		--kubeconfig=$$@


$(serviceFile): $(servicePath)/ $(controllerBin) $(kubeconfigFile)
	$$(file > $$@,$$(controllerServiceConf))


services += $(serviceName)
serviceFiles += $(serviceFile)
files += $(serviceFile) $(kubeconfigFile)

endef

$(eval $(module))
