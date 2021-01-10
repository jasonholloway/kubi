MAKEFLAGS += -r -R
SHELL:=/bin/bash
.DEFAULT_GOAL:=prep

include $(wildcard host/*.mk)
include $(wildcard host/master/*.mk)
include $(wildcard host/worker/*.mk)

prep: $(hostCsrFile) $(preps)
	mkdir -p out/hosts/$(host)
	touch out/hosts/$(host)/prepped

start: $(hostCrtFile) $(starts)
	mkdir -p out/hosts/$(host)
	touch out/hosts/$(host)/prepped

test: $(tests)

stop: $(stops)

clean: $(cleans)
	sudo rm -f $(files)
