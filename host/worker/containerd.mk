mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
gzFile:=out/containerd.tar.gz
binFile:=out/bin/containerd
configFile:=out/etc/containerd/config.toml
serviceFile:=/etc/systemd/system/containerd.service

v:=1.3.6
name:=containerd-$(v)-linux-amd64
url=https://github.com/containerd/containerd/releases/download/v$(v)/$(name).tar.gz

$(gzFile):
	wget $(url) -O $(gzFile)

$(binFile): tmp:=$(shell mktemp -d)
$(binFile): $(gzFile)
	tar xzf $(gzFile) -C $(tmp)
	mv $(tmp)/bin/containerd $(binFile)
	rm -rf $(tmp)
	chmod +x $(binFile)
	touch $(binFile)


define config
[grpc]
  address = "/run/containerd/containerd.sock"

[debug]
  address = "/run/containerd/debug.sock"

[plugins.cri.containerd]
  snapshotter = "overlayfs"
  [plugins.cri.containerd.default_runtime]
    runtime_type = "io.containerd.runtime.v1.linux"
    runtime_engine = "/kubi/bin/runc"
    runtime_root = ""

[plugins.cri.cni]
  bin_dir = "/kubi/opt/cni/bin"
  conf_dir = "/kubi/etc/cni/net.d"
endef

$(configFile): $(mkFile)
	$(file > $@,$(config))



define serviceConfig
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/kubi/bin/containerd \
  --config /kubi/etc/containerd/config.toml
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
endef

$(serviceFile): $(binFile) $(runcBinFile) $(cniBins) $(configFile) $(cniNetworkConfigs) $(mkFile)
	$(file > $@,$(serviceConfig))


services += containerd
files += $(serviceFile) $(configFile) $(binFile)
bigFiles += $(gzFile)
