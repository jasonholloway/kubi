bins:=etcd etcdctl
binPaths:=$(foreach b,$(bins),bin/$(b))

$(binPaths): etcd/version etcd/install.sh
	etcd/install.sh

etcd/done: $(binPaths) 
	etcd/createService.sh
	touch etcd/done

