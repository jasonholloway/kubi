bins:=etcd etcdctl
binPaths:=$(foreach b,$(bins),bin/$(b))
servicePath:=/etc/systemd/system/etcd.service

$(binPaths): etcd/version etcd/install.sh
	etcd/install.sh

$(servicePath): etcd/services.sh
	host=$(host) internalIP=127.0.0.1 etcd/services.sh

etcd/done: $(binPaths) $(servicePath)
	sudo systemctl daemon-reload
	sudo systemctl enable etcd
	sudo systemctl start etcd
	touch etcd/done

