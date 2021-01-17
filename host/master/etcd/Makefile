# Module etcd

_d:=$(dir $(me))

_serviceTemplate:=$(_d)/etcd.service.sh
_service:=$(servicePath)/etcd.service
_dataDir:=/var/kubi/etcd

_bins:=etcd etcdctl
_binFiles:=$(foreach b,$(_bins),$(binPath)/$(b))
_bin:=$(binPath)/etcd

_v:=3.4.10
_name=etcd-v$(_v)-linux-amd64
_url=https://github.com/etcd-io/etcd/releases/download/v$(_v)/$(_name).tar.gz

$(_binFiles): tmp=$(shell mktemp -d)
$(_binFiles): 
	cd $(tmp) \
	&& wget $(_url) -C $(tmp) \
	&& tar xzf $(_name).tar.gz $(foreach b,$(_bins),$(_name)/$(b)) \
	&& chmod +x etcd*/* \
	&& touch etcd*/* \
	&& mv etcd*/* $(abspath $(binPath))/ \
	&& rm -f $(tmp)


define _serviceData
[Unit]
Description=etcd

[Service]
Type=notify
ExecStart=$(abspath $(_bin)) \
	--name $(host) \
	--trusted-ca-file=$(abspath $(ca_crt)) \
	--peer-trusted-ca-file=$(abspath $(ca_crt)) \
	--cert-file=$(abspath $(api_crt)) \
	--key-file=$(abspath $(api_key)) \
	--peer-cert-file=$(abspath $(api_crt)) \
	--peer-key-file=$(abspath $(api_key)) \
	--peer-client-cert-auth \
	--client-cert-auth \
	--initial-advertise-peer-urls https://127.0.0.1:2380 \
	--listen-peer-urls https://127.0.0.1:2380 \
	--listen-client-urls https://127.0.0.1:2379,https://127.0.0.1:2379 \
	--advertise-client-urls https://127.0.0.1:2379 \
	--initial-cluster-token etcd-cluster-0 \
	--initial-cluster $(host)=https://127.0.0.1:2380 \
	--initial-cluster-state new \
	--data-dir=$(abspath $(_dataDir)) \
	--logger=zap
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
endef

$(_service): $(servicePath)/ $(me) $(ca_crt) $(api_crt) $(api_key) $(_bin)
	$(file > $@,$(_serviceData))

_test:
	sudo ETCDCTL_API=3 etcdctl member list \
		--endpoints=https://kubi:2379 \
		--cacert=$(ca_crt) \
		--cert=$(api_crt) \
		--key=$(api_key)

services += etcd
serviceFiles += $(_service)
binFiles += $(_binFiles)
files += $(_service)
tests += $(_test)

