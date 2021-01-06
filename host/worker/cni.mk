
cniBinNames:=bandwidth dhcp flannel host-local loopback portmap sbr tuning bridge firewall host-device ipvlan ptp static vlan
cniBins:=$(foreach n,$(cniBinNames),opt/cni/bin/$(n))

cniNetworkNames:=10-bridge 99-loopback
cniNetworkConfigs:=$(foreach n,$(cniNetworkNames),etc/cni/net.d/${n}.conf)

$(cniBins): oci/cni.sh
	oci/cni.sh

$(cniNetworkConfigs): oci/cni-networks.sh
	oci/cni-networks.sh
