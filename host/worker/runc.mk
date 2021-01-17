# Module runc

_d:=$(dir $(me))
_bin:=out/bin/runc

_v:=1.0.0-rc91
_name:=runc.amd64
_url=https://github.com/opencontainers/runc/releases/download/v$(_v)/$(_name)

$(_bin):
	wget $(_url) -O $@
	chmod +x $@
	touch $@

bigFiles += $(_bin)
