include $(wildcard host/*.mk)
include $(wildcard host/master/*.mk)
include $(wildcard host/worker/*.mk)

prep: $(hostCsrFile) $(preps)

start: $(hostCrtFile) $(starts)

test: $(tests)

stop: $(stops)

clean: $(cleans)
	sudo rm -f $(files)
