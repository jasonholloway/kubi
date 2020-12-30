apiBin:=bin/kube-apiserver
controllerBin:=bin/kube-controller-manager
schedulerBin:=bin/kube-scheduler
proxyBin:=bin/kube-proxy
kubeletBin:=bin/kubelet
kubectlBin:=bin/kubectl
k8sBins:=$(apiBin) $(controllerBin) $(schedulerBin) $(proxyBin) $(kubeletBin) $(kubectlBin)

apiService:=kube-api
apiServiceSh:=k8s/$(apiService).service.sh
apiServiceFile:=/etc/systemd/system/$(apiService).service

controllerService:=kube-controller-manager
controllerServiceSh:=k8s/$(controllerService).service.sh
controllerServiceFile:=/etc/systemd/system/$(controllerService).service

schedulerService:=kube-scheduler
schedulerServiceSh:=k8s/$(schedulerService).service.sh
schedulerServiceFile:=/etc/systemd/system/$(schedulerService).service

kubeletService:=kubelet
kubeletServiceSh:=k8s/$(kubeletService).service.sh
kubeletServiceFile:=/etc/systemd/system/$(kubeletService).service

k8sServiceFiles:=$(apiServiceFile) $(controllerServiceFile) $(schedulerServiceFile) $(kubeletServiceFile)


$(apiServiceFile): $(apiBin) $(apiServiceSh) k8s/encryption.yaml
	host=$(host) internalIP=kubi $(apiServiceSh)


var/kube-controller-manager.kubeconfig: $(kubectlBin) k8s/kube-controller-manager.kubeconfig.sh
	k8s/kube-controller-manager.kubeconfig.sh

$(controllerServiceFile): $(controllerBin) $(controllerServiceSh) var/kube-controller-manager.kubeconfig
	host=$(host) internalIP=kubi $(controllerServiceSh)


var/kube-scheduler.kubeconfig: $(kubectlBin) k8s/kube-scheduler.kubeconfig.sh
	k8s/kube-scheduler.kubeconfig.sh

k8s/kube-scheduler.yaml: k8s/kube-scheduler.yaml.sh
	k8s/kube-scheduler.yaml.sh

$(schedulerServiceFile): $(schedulerBin) $(schedulerServiceSh) var/kube-scheduler.kubeconfig k8s/kube-scheduler.yaml
	host=$(host) internalIP=kubi $(schedulerServiceSh)



var/kubelet.yaml: k8s/kubelet.yaml.sh
	host=$(host) k8s/kubelet.yaml.sh

var/kubelet.kubeconfig: k8s/kubelet.kubeconfig.sh
	host=$(host) k8s/kubelet.kubeconfig.sh

$(kubeletServiceFile): $(kubeletBin) $(kubeletServiceSh) $(containerdService) var/kubelet.yaml var/kubelet.kubeconfig
	host=$(host) internalIP=kubi $(kubeletServiceSh)


$(k8sBins): k8s/version k8s/install.sh
	k8s/install.sh

