MAKEFLAGS += -r -R
SHELL:=/bin/bash
.DEFAULT_GOAL:=prep

preps:=
postPreps:=
starts:=
files:=
cleans:=

include $(sort $(wildcard hub/*.mk))

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

