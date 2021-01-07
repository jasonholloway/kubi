mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))

confPath:=etc/cni/net.d
bridgeConfFile:=$(confPath)/10-bridge.conf

podCidr:="127.64.0.0/64"

define bridgeConf
{
	"cniVersion": "0.3.1",
	"name": "bridge",
	"type": "bridge",
	"bridge": "cnio0",
	"isGateway": true,
	"ipMasq": true,
	"ipam": {
		"type": "host-local",
		"ranges": [
			[{"subnet": "$(podCidr)"}]
		],
		"routes": [{"dst": "0.0.0.0/0"}]
	}
}
endef

$(bridgeConfFile):
	mkdir -p $(@D)
	$(file > $@,$(bridgeConfFile))


localConfFile:=$(confPath)/99-loopback.conf

define localConf
{
	"cniVersion": "0.3.1",
	"name": "lo",
	"type": "loopback"
}
endef

$(localConfFile):
	mkdir -p $(@D)
	$(file > $@,$(localConf))


files += $(bridgeConfFile) $(localConfFile)
