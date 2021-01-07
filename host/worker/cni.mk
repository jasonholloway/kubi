cniBinPath:=bin/cni
cniBinNames:=bandwidth dhcp flannel host-local loopback portmap sbr tuning bridge firewall host-device ipvlan ptp static vlan
cniBinFiles:=$(foreach n,$(cniBinNames),$(cniBinPath)/$(n))

v:=0.8.6
name:=cni-plugins-linux-amd64-v$(v)
url:=https://github.com/containernetworking/plugins/releases/download/v$(v)/$(name).tgz
tmp:=$(shell mktemp -d)

$(cniBinFiles):
	cd $(tmp) \
	&& wget $(url) \
	&& tar xzf $(name).tgz && rm $(name).tgz \
	&& chmod +x ./* \
	&& touch ./* \
	&& mkdir -p $(cniBinPath) \
	&& mv $(tmp)/* $(cniBinPath)/
	rm -rf $(tmp)


binFiles += $(cniBinFiles)
