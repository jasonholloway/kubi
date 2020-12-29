runcBin:=bin/runc

$(runcBin): oci/runc.sh
	oci/runc.sh

containerdBin:=bin/containerd
containerdConfig:=/etc/containerd/config.toml
containerdService:=/etc/systemd/service/containerd.service

$(containerdBin): oci/containerd.sh
	oci/containerd.sh

$(containerdConfig): oci/containerd-config.sh
	oci/containerd-config.sh

$(containerdService): $(containerdBin) $(runcBin) $(containerdConfig) oci/containerd.service.sh
	oci/containerd.service.sh


ociBins:=$(runcBin) $(containerdBin)
