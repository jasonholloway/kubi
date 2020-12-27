bins:=kube-apiserver kube-controller-manager kube-scheduler kubectl kubelet kube-proxy
binPaths:=$(foreach b,$(bins),bin/$(b))

$(binPaths): k8s/version k8s/install.sh
	k8s/install.sh

k8s/done: $(binPaths) 
	k8s/services.sh
	touch k8s/done

