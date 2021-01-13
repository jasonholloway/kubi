serviceName:=etcd
serviceFile:=$(servicePath)/$(serviceName).service
etcdDataDir:=/var/kubi/etcd

etcdBins:=etcd etcdctl
etcdBinFiles:=$(foreach b,$(etcdBins),$(binPath)/$(b))

v:=3.4.10
name=etcd-v$(v)-linux-amd64
url=https://github.com/etcd-io/etcd/releases/download/v$(v)/$(name).tar.gz


define etcdServiceConf
[Unit]
Description=etcd

[Service]
Type=notify
ExecStart=$(abspath $(binPath)/etcd) \
	--name $(host) \
	--trusted-ca-file=$(abspath $(caCrtFile)) \
	--peer-trusted-ca-file=$(abspath $(caCrtFile)) \
	--cert-file=$(abspath $(apiCrtFile)) \
	--key-file=$(abspath $(apiKeyFile)) \
	--peer-cert-file=$(abspath $(apiCrtFile)) \
	--peer-key-file=$(abspath $(apiKeyFile)) \
	--peer-client-cert-auth \
	--client-cert-auth \
	--initial-advertise-peer-urls https://127.0.0.1:2380 \
	--listen-peer-urls https://127.0.0.1:2380 \
	--listen-client-urls https://127.0.0.1:2379,https://127.0.0.1:2379 \
	--advertise-client-urls https://127.0.0.1:2379 \
	--initial-cluster-token etcd-cluster-0 \
	--initial-cluster $(host)=https://127.0.0.1:2380 \
	--initial-cluster-state new \
	--data-dir=$(abspath $(etcdDataDir)) \
	--logger=zap
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef


define module

tmp=$(mktemp -d)

$(etcdBinFiles): 
	cd $$(tmp) \
	&& wget $(url) -C $$(tmp) \
	&& tar xzf $(name).tar.gz $(foreach b,$(etcdBins),$(name)/$(b)) \
	&& chmod +x etcd*/* \
	&& touch etcd*/* \
	&& mv etcd*/* $(abspath $(binPath))/ \
	&& rm -f $$(tmp)

$(serviceFile): $(servicePath)/ $(caCrtFile) $(apiCrtFile) $(apiKeyFile) $(etcdBinFiles)
	$$(file > $$@,$$(etcdServiceConf))

etcdTest:
	sudo ETCDCTL_API=3 etcdctl member list \
		--endpoints=https://kubi:2379 \
		--cacert=$(caCrtFile) \
		--cert=$(apiCrtFile) \
		--key=$(apiKeyFile)

services += $(serviceName)
serviceFiles += $(serviceFile)
binFiles += $(etcdBinFiles)
files += $(serviceFile)
tests += etcdTest

endef

$(eval $(module))
