# Module k8sBins

_path:=$(binPath)
_url=https://storage.googleapis.com/kubernetes-release/release/v$(v)/bin/linux/amd64
_v=1.18.6

define _download

$(2)=$(_path)/$(1)

$(2):
	mkdir -p $@
	wget --show-progress --timestamping $(_url)/$(1) -O $@ \
	&& chmod +x $@

binFiles += $(2)

endef

