# Module containerd

_gz:=$(out)/containerd.tar.gz
_bin:=$(binPath)/containerd
_config:=$(out)/containerd/config.toml
_service:=$(out)/systemd/containerd.service
_sock:=/var/kubi/run/containerd/containerd.sock
_debugSock:=/var/kubi/run/containerd/debug.sock

_v:=1.3.6
_name:=containerd-$(_v)-linux-amd64
_url=https://github.com/containerd/containerd/releases/download/v$(_v)/$(_name).tar.gz

$(_gz):
	wget $(_url) -O $@

$(_bin): tmp:=$(shell mktemp -d)
$(_bin): $(_gz)
	tar xzf $(_gz) -C $(tmp)
	mv $(tmp)/bin/containerd $@
	rm -rf $(tmp)
	chmod +x $@
	touch $@


define _configData
[grpc]
	address = "$(_sock)"

[debug]
	address = "$(_debugSock)"

[plugins.cri.containerd]
	snapshotter = "overlayfs"
	[plugins.cri.containerd.default_runtime]
		runtime_type = "io.containerd.runtime.v1.linux"
		runtime_engine = "$(runc_bin)"
		runtime_root = ""

[plugins.cri.cni]
	bin_dir = "$(cni_binPath)"
	conf_dir = "$(cni_confPath)"
endef

$(_config): $(me) $(cni_binsDownloaded) $(runc_bin) $(cni_confs)
	mkdir -p $(@D)
	$(file > $@,$(_configData))


define _serviceData
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=$(_bin) \
	--config $(_config)
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

$(_service): $(me) $(_bin) $(_config)
	$(file > $@,$(_serviceData))


services += containerd
serviceFiles += $(_service)
files += $(_service) $(_config) $(_bin)
bigFiles += $(_gz)
