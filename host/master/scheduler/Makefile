# Module scheduler

_key:=$(out)/scheduler.key
_csr:=$(out)/scheduler.csr
_crt:=$(out)/scheduler.crt

$(_key):
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048

$(_csr): $(_key)
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-scheduler/CN=system:kube-scheduler" \
		-key $(_key) \
		-out $@

preps += $(_csr)
files += $(_crt) $(_csr)
keyFiles += $(_key)


_serviceName:=kube-scheduler
_service:=$(servicePath)/$(_serviceName).service
_kubeconfig:=out/etc/scheduler.kubeconfig
_config:=out/etc/scheduler.yaml
_bin:=$(k8s_binPath)/kube-scheduler

_cluster:=kubi
_user:=system:kube-scheduler

$(_kubeconfig): $(kubectl_bin) $(ca_crt)
	kubectl config set-cluster $(_cluster) \
		--certificate-authority=$(abspath $(ca_crt)) \
		--embed-certs=true \
		--server=https://kubi:6443 \
		--kubeconfig=$@
	kubectl config set-credentials $(_user) \
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


define _configData
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: $(abspath $(_kubeconfig))
leaderElection:
  leaderElect: true
endef

$(_config): $(_kubeconfig)
	$(file > $@,$(_config))


define _serviceData
[Unit]
Description=Kubernetes Scheduler

[Service]
ExecStart=$(abspath $(_bin)) \
	--config=$(abspath $(_config)) \
	--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef

$(_service): $(servicePath)/ $(_bin) $(_config)
	$(file > $@,$(_serviceData))

services += $(_serviceName)
serviceFiles += $(_service)
files += $(_service) $(_config) $(_kubeconfig)
