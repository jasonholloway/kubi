# Module etcd

_d:=$(dir $(lastword $(MAKEFILE_LIST)))

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

$(_service): $(servicePath)/ $(ca_crt) $(api_crt) $(api_key) $(_binFiles)
	$(file > $@,$(shell $(_serviceTemplate) $(host) $(_bin) $(ca_crt) $(api_crt) $(api_key) $(_dataDir)))

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

