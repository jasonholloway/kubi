
apiBin:=bin/kube-apiserver
controllerBin:=bin/kube-controller-manager
schedulerBin:=bin/kube-scheduler
proxyBin:=bin/kube-proxy
kubectlBin:=bin/kubectl
k8sBins:=$(apiBin) $(controllerBin) $(schedulerBin) $(proxyBin) $(kubectlBin) $(kubeletBin)
$(k8sBins): k8s/version k8s/install.sh
	k8s/install.sh


