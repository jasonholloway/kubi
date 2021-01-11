serviceName:=kube-scheduler
serviceFile:=$(servicePath)/$(serviceName).service
kubeconfigFile:=out/etc/scheduler.kubeconfig
configFile:=out/etc/scheduler.yaml


define schedulerConfig
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
	kubeconfig: $(abspath $(kubeconfigFile))
leaderElection:
	leaderElect: true
endef


define schedulerServiceConf
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


cluster:=kubi
user:=system:kube-scheduler

define module

$(kubeconfigFile): $(kubectlBin)
	kubectl config set-cluster $(cluster) \
		--certificate-authority=$(abspath $(caCrtFile)) \
		--embed-certs=true \
		--server=https://kubi:6443 \
		--kubeconfig=$$@
	kubectl config set-credentials $(user) \
		--client-certificate=$(abspath $(schedulerCrtFile)) \
		--client-key=$(abspath $(schedulerKeyFile)) \
		--embed-certs=true \
		--kubeconfig=$$@
	kubectl config set-context default \
		--cluster=$(cluster) \
		--user=$(user) \
		--kubeconfig=$$@
	kubectl config use-context default \
		--kubeconfig=$$@

$(configFile): $(kubeconfigFile)
	$$(file > $$@,$$(schedulerConfig))

$(serviceFile): $(servicePath)/ $(schedulerBin) $(configFile)
	$$(file > $$@,$$(schedulerServiceConf))


services += $(serviceName)
serviceFiles += $(serviceFile)
files += $(serviceFile) $(configfile) $(kubeconfigFile)

endef

$(eval $(module))
