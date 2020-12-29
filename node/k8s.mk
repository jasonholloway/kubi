apiBin:=bin/kube-apiserver
controllerBin:=bin/kube-controller-manager
schedulerBin:=bin/kube-scheduler
proxyBin:=bin/kube-proxy
kubeletBin:=bin/kubelet
kubectlBin:=bin/kubectl
k8sBins:=$(apiBin) $(controllerBin) $(schedulerBin) $(proxyBin) $(kubeletBin) $(kubectlBin)


apiServiceName:=kube-api
apiServiceSh:=k8s/$(apiServiceName).service.sh
apiService:=/etc/systemd/system/$(apiServiceName).service

controllerServiceName:=kube-controller-manager
controllerServiceSh:=k8s/$(controllerServiceName).service.sh
controllerService:=/etc/systemd/system/$(controllerServiceName).service

schedulerServiceName:=kube-scheduler
schedulerServiceSh:=k8s/$(schedulerServiceName).service.sh
schedulerService:=/etc/systemd/system/$(schedulerServiceName).service

kubeletServiceName:=kubelet
kubeletServiceSh:=k8s/$(kubeletServiceName).service.sh
kubeletService:=/etc/systemd/system/$(kubeletServiceName).service

k8sServices:=$(apiService) $(controllerService) $(schedulerService) $(kubeletService)


$(apiService): $(apiBin) $(apiServiceSh) k8s/encryption.yaml
	host=$(host) internalIP=kubi $(apiServiceSh)


var/kube-controller-manager.kubeconfig: $(kubectlBin) k8s/kube-controller-manager.kubeconfig.sh
	k8s/kube-controller-manager.kubeconfig.sh

$(controllerService): $(controllerBin) $(controllerServiceSh) var/kube-controller-manager.kubeconfig
	host=$(host) internalIP=kubi $(controllerServiceSh)


var/kube-scheduler.kubeconfig: $(kubectlBin) k8s/kube-scheduler.kubeconfig.sh
	k8s/kube-scheduler.kubeconfig.sh

k8s/kube-scheduler.yaml: k8s/kube-scheduler.yaml.sh
	k8s/kube-scheduler.yaml.sh

$(schedulerService): $(schedulerBin) $(schedulerServiceSh) var/kube-scheduler.kubeconfig k8s/kube-scheduler.yaml
	host=$(host) internalIP=kubi $(schedulerServiceSh)



k8s/kubelet.yaml: k8s/kubelet.yaml.sh
	host=$(host) k8s/kubelet.yaml.sh

var/kubelet.kubeconfig: k8s/kubelet.kubeconfig.sh
	host=$(host) k8s/kubelet.kubeconfig.sh

$(kubeletService): $(kubeletBin) $(kubeletServiceSh) $(containerdService) k8s/kubelet.yaml var/kubelet.kubeconfig
	host=$(host) internalIP=kubi $(kubeletServiceSh)


$(k8sBins): k8s/version k8s/install.sh
	k8s/install.sh

