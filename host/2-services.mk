
servicesStarted:=$(out)/servicesStarted

$(servicesStarted): $(serviceFiles)
	for f in $(serviceFiles); do \
		sudo systemctl disable --now $$(basename $$f); \
		sudo systemctl enable --now $$(realpath $$f); \
	done
	touch $@

stopServices:
	for f in $$PWD/$(out)/systemd/*.service; do \
		sudo systemctl disable --now $$(basename $$f); \
	done
	rm $(servicesStarted)


starts += $(servicesStarted)
stops += stopServices
