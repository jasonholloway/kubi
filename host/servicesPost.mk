# Last

servicesStarted:=$(out)/servicesStarted

$(servicesStarted): $(serviceFiles)
	:> $@
	for f in $(serviceFiles); do \
		sudo systemctl disable --now $$(basename $$f); \
		sudo systemctl enable --now $$(realpath $$f); \
		echo $$(basename $$f) >> $@; \
	done

stopServices:
	if [ -e $(servicesStarted) ]; then \
		while read s; do \
			sudo systemctl disable --now $$s; \
		done; \
	fi
	-rm $(servicesStarted)

starts += $(servicesStarted)
stops += stopServices
