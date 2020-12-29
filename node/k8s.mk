
k8sServiceNames:=kube-api
k8sServices:=$(foreach s,$(k8sServiceNames),/etc/systemd/system/$(s).service)

var:
	mkdir -p var

apiServiceName:=kube-api
apiServiceSh:=k8s/$(apiServiceName).service.sh
apiService:=/etc/systemd/system/$(apiServiceName).service

$(apiService): $(apiBin) $(apiServiceSh) k8s/encryption.yaml
	host=$(host) internalIP=kubi $(apiServiceSh)


controllerServiceName:=kube-controller-manager
controllerServiceSh:=k8s/$(controllerServiceName).service.sh
controllerService:=/etc/systemd/system/$(controllerServiceName).service

var/kube-controller-manager.kubeconfig: $(kubectlBin) k8s/kube-controller-manager.kubeconfig.sh var
	k8s/kube-controller-manager.kubeconfig.sh

$(controllerService): $(controllerBin) $(controllerServiceSh) var/kube-controller-manager.kubeconfig
	host=$(host) internalIP=kubi $(controllerServiceSh)


schedulerServiceName:=kube-scheduler
schedulerServiceSh:=k8s/$(schedulerServiceName).service.sh
schedulerService:=/etc/systemd/system/$(schedulerServiceName).service

var/kube-scheduler.kubeconfig: $(kubectlBin) k8s/kube-scheduler.kubeconfig.sh var
	k8s/kube-scheduler.kubeconfig.sh

k8s/kube-scheduler.yaml: k8s/kube-scheduler.yaml.sh
	k8s/kube-scheduler.yaml.sh

$(schedulerService): $(schedulerBin) $(schedulerServiceSh) var/kube-scheduler.kubeconfig k8s/kube-scheduler.yaml
	host=$(host) internalIP=kubi $(schedulerServiceSh)



apiBin:=bin/kube-apiserver
controllerBin:=/bin/kube-controller-manager
schedulerBin:=/bin/kube-scheduler
proxyBin:=/bin/kube-proxy
kubeletBin:=/bin/kubelet
kubectlBin:=/bin/kubectl
k8sBins:=$(apiBin) $(controllerBin) $(schedulerBin) $(proxyBin) $(kubeletBin) $(kubectlBin)

$(k8sBins): k8s/version k8s/install.sh
	k8s/install.sh


