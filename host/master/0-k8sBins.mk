bins:=kube-apiserver kube-controller-manager kube-scheduler
k8sBinFiles:=$(foreach b,$(bins),$(binPath)/$(b))

v=1.18.6
url=https://storage.googleapis.com/kubernetes-release/release/v$(v)/bin/linux/amd64
k8sBinUrls:=$(foreach b,$(bins),$(url)/$(b))

tmp=$(mktemp -d)

$(k8sBinFiles):
	cd $(tmp) \
	&& wget --show-progress --timestamping $(k8sBinUrls) \
	&& chmod +x * \
	&& mkdir -p $(binPath) \
	&& mv * $(binPath)/ 
	rm -rf $(tmp)

apiBin:=$(binPath)/kube-apiserver
controllerBin:=$(binPath)/kube-controller-manager
schedulerBin:=$(binPath)/kube-scheduler

preps += $(k8sBinFiles)
binFiles += $(k8sBinFiles)
