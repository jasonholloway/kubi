services += scheduler

schedulerServiceSh:=k8s/kube-scheduler.service.sh
schedulerServiceFile:=/etc/systemd/system/kube-scheduler.service

dir:=master/scheduler

var/kube-scheduler.kubeconfig: $(kubectlBin) k8s/kube-scheduler.kubeconfig.sh
	k8s/kube-scheduler.kubeconfig.sh

k8s/kube-scheduler.yaml: k8s/kube-scheduler.yaml.sh
	k8s/kube-scheduler.yaml.sh

$(schedulerServiceFile): $(schedulerBin) $(schedulerServiceSh) var/kube-scheduler.kubeconfig k8s/kube-scheduler.yaml
	host=$(host) internalIP=kubi $(schedulerServiceSh)

schedulerTest:

schedulerClean:
	-sudo systemctl stop kube-scheduler
	-sudo systemctl disable kube-scheduler
	-rm -rf $(schedulerServiceFile)
	-sudo systemctl daemon-reload

