# Module k8sMaster

_binNames:=kube-apiserver kube-controller-manager kube-scheduler
_binPath:=$(binPath)
_bins:=$(foreach b,$(_binNames),$(_binPath)/$(b))

_v=1.18.6
_url=https://storage.googleapis.com/kubernetes-release/release/v$(v)/bin/linux/amd64
_binUrls:=$(foreach b,$(_binNames),$(_url)/$(b))


$(eval $(call k8sBins_download,kube-scheduler,_schedulerBin))
$(warning BLAH $(_schedulerBin))


$(_bins): tmp:=$(mktemp -d)
$(_bins):
	cd $(tmp) \
	&& wget --show-progress --timestamping $(_binUrls) \
	&& chmod +x * \
	&& mkdir -p $(binPath) \
	&& mv * $(binPath)/ 
	rm -rf $(tmp)


preps += $(_bins)
binFiles += $(_bins)
