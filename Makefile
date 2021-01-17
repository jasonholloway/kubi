MAKEFLAGS += -r -R
SHELL:=/bin/bash
.DEFAULT_GOAL:=out/prepped

preps:=
postPreps:=
starts:=
files:=
cleans:=

me:=$(lastword $(MAKEFILE_LIST))
include $(shell ./makemodule $$(find hub -name '*.mk' -o -name 'Makefile'))

out/prepped: $(preps)
	touch $@

out/postPrepped: out/prepped $(postPreps)
	touch $@

out/started: out/postPrepped $(starts)
	touch $@

stop: $(stops)

clean: $(cleans)


out/etc:
	mkdir -p out/etc

out/var:
	mkdir -p out/var


# gruesomely needed to stop deletion of supposedly-intermediate files

