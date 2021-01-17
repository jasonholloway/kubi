# Module k8sWorker

_binNames:=kubectl kubelet kube-proxy
_binPath:=$(binPath)
_bins:=$(foreach b,$(_binNames),$(_binPath)/$(b))

_v=1.18.6
_url=https://storage.googleapis.com/kubernetes-release/release/v$(_v)/bin/linux/amd64
_binUrls:=$(foreach b,$(_binNames),$(_url)/$(b))

$(_bins): tmp:=$(shell mktemp -d)
$(_bins):
	cd $(tmp) \
	&& wget --show-progress --timestamping $(_binUrls) \
	&& chmod +x * \
	&& mkdir -p $(binPath) \
	&& mv * $(binPath)/ 
	rm -rf $(tmp)

kubectl_bin:=$(binPath)/kubectl
proxy_bin:=$(binPath)/kube-proxy

binFiles += $(_bins)
