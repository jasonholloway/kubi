bins:=etcd etcdctl
binPaths:=$(foreach b,$(bins),bin/$(b))
servicePath:=/etc/systemd/system/etcd.service

$(binPaths): etcd/version etcd/install.sh
	etcd/install.sh

$(servicePath): etcd/services.sh
	host=$(host) internalIP=kubi etcd/services.sh

etcd/done: $(binPaths) $(servicePath)
	sudo systemctl daemon-reload
	sudo systemctl enable etcd
	sudo systemctl start etcd
	touch etcd/done

etcd/test:
	sudo ETCDCTL_API=3 etcdctl member list \
		--endpoints=https://kubi:2379 \
		--cacert=/kubi/ca/crt \
		--cert=/kubi/api/crt \
		--key=/kubi/api/key

.PHONY:etcd/test
