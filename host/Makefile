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

me:=$(lastword $(MAKEFILE_LIST))
include $(shell ./makemodule $$(find $(dir $(me)) -name '*.mk' -o -name 'Makefile' -a ! -path "$(me)"))


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
