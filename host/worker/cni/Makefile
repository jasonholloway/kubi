# Module cni

_confPath:=$(out)/cni/
_bridgeConf:=$(_confPath)10-bridge.conflist
_localConf:=$(_confPath)99-loopback.conf
_confs:=$(_bridgeConf) $(_localConf)
_podCidr:=127.64.0.0/16

_binPath:=$(binPath)/cni
_binNames:=bandwidth dhcp flannel host-local loopback portmap sbr tuning bridge firewall host-device ipvlan ptp static vlan
_bins:=$(foreach n,$(_binNames),$(_binPath)/$(n))

_v:=0.8.6
_name:=cni-plugins-linux-amd64-v$(_v)
_url:=https://github.com/containernetworking/plugins/releases/download/v$(_v)/$(_name).tgz

$(_confPath):
	mkdir -p $@

$(_bins): tmp:=$(shell mktemp -d)
$(_bins):
	cd $(tmp) \
	&& wget $(_url) \
	&& tar xzf $(_name).tgz && rm $(_name).tgz \
	&& chmod +x ./* \
	&& touch ./* \
	&& mkdir -p $(_binPath) \
	&& mv $(tmp)/* $(_binPath)/ \
	&& rm -rf $(tmp)


define _bridgeConfData
{
	"cniVersion": "0.3.1",
	"name": "bridge",
	"plugins": [
		{
			"type": "bridge",
			"bridge": "cnio0",
			"ipam": {
				"type": "host-local",
				"ranges": [
					[{"subnet": "$(_podCidr)"}]
				],
				"routes": [{"dst": "0.0.0.0/0"}]
			},
			"isGateway": true,
			"ipMasq": true
		},
		{
			"type": "portmap",
			"capabilities": {"portMappings":true}
		}
	]
}
endef

$(_bridgeConf): $(_confPath) $(me)
	$(file > $@,$(_bridgeConfData))


define _localConfData
{
	"cniVersion": "0.3.1",
	"name": "lo",
	"type": "loopback"
}
endef

$(_localConf): $(_confPath) $(me)
	$(file > $@,$(_localConfData))

preps += $(_confs)
binFiles += $(_bins)
files += $(_confs)
