MAKEFLAGS += -r -R
SHELL:=/bin/bash
.DEFAULT_GOAL:=prep

preps:=
starts:=
files:=
cleans:=

include $(sort $(wildcard hub/*.mk))

prep: $(preps)

start: $(starts)

stop: $(stops)

clean: $(cleans)


out/etc:
	mkdir -p out/etc

out/var:
	mkdir -p out/var


# gruesomely needed to stop deletion of supposedly-intermediate files

