# First

servicePath:=$(out)/systemd
services:=
serviceFiles:=

$(servicePath)/:
	mkdir -p $@
