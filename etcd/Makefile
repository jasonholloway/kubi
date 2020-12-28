etcdBinNames:=etcd etcdctl
etcdBins:=$(foreach b,$(etcdBinNames),bin/$(b))
etcdService:=/etc/systemd/system/etcd.service

$(etcdBins): etcd/version etcd/install.sh
	etcd/install.sh

$(etcdService): etcd/services.sh ca/crt api/crt api/key
	host=$(host) internalIP=kubi etcd/services.sh

etcd/test:
	sudo ETCDCTL_API=3 etcdctl member list \
		--endpoints=https://kubi:2379 \
		--cacert=/kubi/ca/crt \
		--cert=/kubi/api/crt \
		--key=/kubi/api/key

.PHONY:etcd/test
