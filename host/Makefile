MAKEFLAGS += -r -R
SHELL:=/bin/bash
.DEFAULT_GOAL:=prep

host:=$(shell hostname)
out:=out/hosts/$(host)
binPath:=bin
servicePath:=$(out)/systemd

preps:=
starts:=
services:=
serviceFiles:=
files:=

include host/0-caCrt.mk
include host/1-hostCrt.mk
include host/1-etcHosts.mk
include $(sort $(wildcard host/master/*.mk))
# include $(sort $(wildcard host/worker/*.mk))
include host/2-services.mk

$(out)/:
	mkdir -p $(out)

prep: $(out)/ $(preps)
	touch $(out)/prepped

start: $(out)/ $(starts)
	echo START $(starts) >&2
	touch $(out)/prepped

test: $(tests)

stop: $(stops)

clean: $(cleans)
	sudo rm -f $(files)


$(servicePath)/:
	mkdir -p $@
