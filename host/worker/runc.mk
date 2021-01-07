mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
binFile:=out/bin/runc

v:=1.0.0-rc91
name:=runc.amd64
url=https://github.com/opencontainers/runc/releases/download/v$(v)/$(name)

$(binFile):
	wget $(url) -O $@
	chmod +x $@
	touch $@

bigFiles += $(binFile)
