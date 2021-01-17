# Module k8s

_binNames:=kube-apiserver kube-controller-manager kube-scheduler
_bins:=$(foreach b,$(_binNames),$(binPath)/$(b))

_v=1.18.6
_url=https://storage.googleapis.com/kubernetes-release/release/v$(v)/bin/linux/amd64
_binUrls:=$(foreach b,$(_binNames),$(_url)/$(b))

$(k8sBinFiles): tmp:=$(mktemp -d)
$(k8sBinFiles):
	cd $(tmp) \
	&& wget --show-progress --timestamping $(_binUrls) \
	&& chmod +x * \
	&& mkdir -p $(binPath) \
	&& mv * $(binPath)/ 
	rm -rf $(tmp)

api_bin:=$(binPath)/kube-apiserver
controller_bin:=$(binPath)/kube-controller-manager
scheduler_bin:=$(binPath)/kube-scheduler

preps += $(_bins)
binFiles += $(_bins)
