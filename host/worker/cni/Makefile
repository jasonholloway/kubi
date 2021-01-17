# Module cni

_d:=$(dir $(lastword $(MAKEFILE_LIST)))
_bridgeConfTemplate:=$(_d)bridge.conf.sh
_localConfTemplate:=$(_d)local.conf.sh

_confPath:=$(out)/cni/
_bridgeConf:=$(_confPath)10-bridge.conf
_localConf:=$(_confPath)99-loopback.conf
_confs:=$(_bridgeConf) $(_localConf)
_podCidr:="127.64.0.0/64"

_binPath:=bin/cni
_binNames:=bandwidth dhcp flannel host-local loopback portmap sbr tuning bridge firewall host-device ipvlan ptp static vlan
_bins:=$(foreach n,$(_binNames),$(_binPath)/$(n))
_binsDownloaded:=$(out)/cniPluginsDownloaded

_v:=0.8.6
_name:=cni-plugins-linux-amd64-v$(_v)
_url:=https://github.com/containernetworking/plugins/releases/download/v$(_v)/$(_name).tgz

$(_confPath):
	mkdir -p $@

$(_binsDownloaded): tmp:=$(shell mktemp -d)
$(_binsDownloaded):
	cd $(tmp) \
	&& wget $(_url) \
	&& tar xzf $(_name).tgz && rm $(_name).tgz \
	&& chmod +x ./* \
	&& touch ./* \
	&& mkdir -p $(_binPath) \
	&& mv $(tmp)/* $(_binPath)/
	rm -rf $(tmp)

$(_bridgeConf): $(_confPath) $(_bridgeConfTemplate)
	$(file > $@,$(shell $(_bridgeConfTemplate)))

$(_localConf): $(_confPath) $(_localConfTemplate)
	$(file > $@,$(shell $(_localConfTemplate)))

preps += $(_confs)
binFiles += $(_bins)
files += $(_confs)
