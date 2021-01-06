services += containerd

containerdBin:=bin/containerd
containerdConfig:=etc/containerd/config.toml
containerdServiceFile:=/etc/systemd/system/containerd.service

d:=worker/oci

$(containerdBin): $(d)/containerd.sh
	$(d)/containerd.sh

$(containerdConfig): $(d)/containerd-config.sh
	$(d)/containerd-config.sh

$(containerdServiceFile): $(containerdBin) $(runcBin) $(cniBins) $(containerdConfig) $(cniNetworkConfigs) $(d)/containerd.service.sh
	$(d)/containerd.service.sh

containerdTest:

containerdClean:
	-sudo systemctl stop containerd
	-sudo systemctl disable containerd
	-rm -rf $(containerdServiceFile)



runcBin:=bin/runc

$(runcBin): $(d)/runc.sh
	$(d)/runc.sh

