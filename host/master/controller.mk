services += controller

controllerServiceSh:=k8s/kube-controller-manager.service.sh
controllerServiceFile:=/etc/systemd/system/kube-controller-manager.service

dir:=master/controller

var/kube-controller-manager.kubeconfig: $(kubectlBin) k8s/kube-controller-manager.kubeconfig.sh
	k8s/kube-controller-manager.kubeconfig.sh

$(controllerServiceFile): $(controllerBin) $(controllerServiceSh) var/kube-controller-manager.kubeconfig
	host=$(host) internalIP=kubi $(controllerServiceSh)

controllerTest:

controllerClean:
