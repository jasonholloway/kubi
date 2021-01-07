serviceFile:=/etc/systemd/system/kube-scheduler.service
kubeconfigFile:=out/etc/scheduler.kubeconfig
configFile:=out/etc/scheduler.yaml

cluster:=kubi
user:=system:kube-scheduler

$(kubeconfigFile): $(kubectlBin)
	kubectl config set-cluster $(cluster) \
		--certificate-authority=$(abspath $(caCrtFile)) \
		--embed-certs=true \
		--server=https://kubi:6443 \
		--kubeconfig=$@
	kubectl config set-credentials $(user) \
		--client-certificate=$(abspath $(schedulerCrtFile)) \
		--client-key=$(abspath $(schedulerKeyFile)) \
		--embed-certs=true \
		--kubeconfig=$@
	kubectl config set-context default \
		--cluster=$(cluster) \
		--user=$(user) \
		--kubeconfig=$@
	kubectl config use-context default \
		--kubeconfig=$@



define k8sConfig
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
	kubeconfig: $(abspath $(kubeconfigFile))
leaderElection:
	leaderElect: true
endef

$(configFile): $(kubeconfigFile)
	$(file > $@,$(k8sConfig))



define serviceConf
[Unit]
Description=Kubernetes Scheduler

[Service]
ExecStart=$(abspath $(schedulerBin)) \
	--config=$(abspath $(configFile)) \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef

$(serviceFile): $(schedulerBin) $(configFile)
	$(file > $@,$(serviceConf))


services += kube-scheduler
files += $(serviceFile) $(configfile) $(kubeconfigFile)
