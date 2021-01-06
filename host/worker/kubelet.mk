services += kubelet

kubeletServiceSh:=k8s/kubelet.service.sh
kubeletServiceFile:=/etc/systemd/system/kubelet.service

kubeletBin:=bin/kubelet

var/kubelet.yaml: k8s/kubelet.yaml.sh
	host=$(host) k8s/kubelet.yaml.sh

var/kubelet.kubeconfig: k8s/kubelet.kubeconfig.sh
	host=$(host) k8s/kubelet.kubeconfig.sh

$(kubeletServiceFile): $(kubeletBin) $(kubeletServiceSh) $(containerdService) var/kubelet.yaml var/kubelet.kubeconfig
	host=$(host) internalIP=kubi $(kubeletServiceSh)

kubeletTest:

kubeletClean:
	-sudo systemctl stop kubelet
	-sudo systemctl disable kubelet
	-sudo rm $(kubeletServiceFile)
