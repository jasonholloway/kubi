etcdBinNames:=etcd etcdctl
etcdBins:=$(foreach b,$(etcdBinNames),bin/$(b))
etcdService:=etcd
etcdServiceFile:=/etc/systemd/system/$(etcdService).service

$(etcdBins): etcd/version etcd/install.sh
	etcd/install.sh

$(etcdServiceFile): etcd/services.sh ca/crt api/crt api/key
	host=$(host) internalIP=kubi etcd/services.sh

etcd/test:
	sudo ETCDCTL_API=3 etcdctl member list \
		--endpoints=https://kubi:2379 \
		--cacert=/kubi/ca/crt \
		--cert=/kubi/api/crt \
		--key=/kubi/api/key

.PHONY:etcd/test
