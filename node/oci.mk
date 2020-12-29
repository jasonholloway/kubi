runcBin:=bin/runc

containerdBin:=bin/containerd
containerdConfig:=etc/containerd/config.toml
containerdService:=/etc/systemd/system/containerd.service

cniBinNames:=bandwidth dhcp flannel host-local loopback portmap sbr tuning bridge firewall host-device ipvlan ptp static vlan
cniBins:=$(foreach n,$(cniBinNames),opt/cni/bin/$(n))

cniNetworkNames:=10-bridge 99-loopback
cniNetworkConfigs:=$(foreach n,$(cniNetworkNames),etc/cni/net.d/${n}.conf)


$(runcBin): oci/runc.sh
	oci/runc.sh


$(containerdBin): oci/containerd.sh
	oci/containerd.sh

$(containerdConfig): oci/containerd-config.sh
	oci/containerd-config.sh

$(containerdService): $(containerdBin) $(runcBin) $(cniBins) $(containerdConfig) $(cniNetworkConfigs) oci/containerd.service.sh
	oci/containerd.service.sh


$(cniBins): oci/cni.sh
	oci/cni.sh


$(cniNetworkConfigs): oci/cni-networks.sh
	oci/cni-networks.sh


ociBins:=$(runcBin) $(containerdBin) $(cniBins)
