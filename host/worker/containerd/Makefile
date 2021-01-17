# Module containerd

_d:=$(dir $(me))
_gz:=out/containerd.tar.gz
_bin:=out/bin/containerd
_config:=out/etc/containerd/config.toml
_service:=/etc/systemd/system/containerd.service
_sock:=/var/kubi/run/containerd/containerd.sock
_debugSock:=/var/kubi/run/containerd/debug.sock

_configTemplate:=$(_d)/config.toml.sh
_serviceTemplate:=$(_d)/containerd.service.sh

_v:=1.3.6
_name:=containerd-$(_v)-linux-amd64
_url=https://github.com/containerd/containerd/releases/download/v$(_v)/$(_name).tar.gz

$(_gz):
	wget $(_url) -O $(_gz)

$(_bin): tmp:=$(shell mktemp -d)
$(_bin): $(_gz)
	tar xzf $(_gz) -C $(tmp)
	mv $(tmp)/bin/containerd $(_bin)
	rm -rf $(tmp)
	chmod +x $(_bin)
	touch $(_bin)

$(_config): $(_configTemplate) $(cni_binsDownloaded)
	$(file > $@,$(shell $(_configTemplate) $(_sock) $(_debugSock)))

$(_service): $(_serviceTemplate) $(_bin) $(runc_bin) $(_config) $(cni_confs)
	$(file > $@,$(shell $(_serviceTemplate)))


services += containerd
serviceFiles += $(_service)
files += $(_service) $(_config) $(_bin)
bigFiles += $(_gz)
