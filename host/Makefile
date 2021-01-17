MAKEFLAGS += -r -R
SHELL:=/bin/bash
.DEFAULT_GOAL:=prep

host:=$(shell hostname)
out:=$(abspath out/hosts/$(host))
binPath:=$(abspath bin)

preps:=
starts:=
files:=

me:=$(lastword $(MAKEFILE_LIST))
include $(shell ./makemodule $$(find $(dir $(me)) -name '*.mk' -o -name 'Makefile' -a ! -path "$(me)"))

$(out)/:
	mkdir -p $(out)

prep: $(out)/ $(preps)
	touch $(out)/prepped

start: $(out)/ $(starts)
	touch $(out)/prepped

test: $(tests)

stop: $(stops)

clean: $(cleans)
	sudo rm -f $(files)

