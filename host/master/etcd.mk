services += etcd

etcdServiceFile:=/etc/systemd/system/etcd.service

etcdBinNames:=etcd etcdctl
etcdBins:=$(foreach b,$(etcdBinNames),bin/$(b))

etcdDir:=master/etcd

$(etcdBins): $(etcdDir)/version $(etcdDir)/install.sh
	etcd/install.sh

$(etcdServiceFile): $(etcdDir)/services.sh ca/crt api/crt api/key
	host=$(host) internalIP=kubi etcd/services.sh

etcdTest:
	sudo ETCDCTL_API=3 etcdctl member list \
		--endpoints=https://kubi:2379 \
		--cacert=/kubi/ca/crt \
		--cert=/kubi/api/crt \
		--key=/kubi/api/key

etcdClean:
	-sudo systemctl stop etcd
	-sudo systemctl disable etcd
	-rm -rf $(etcdServiceFile)
