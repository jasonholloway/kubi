
servicesStarted:=$(out)/servicesStarted

$(servicesStarted): $(serviceFiles)
	for f in $$PWD/$(out)/systemd/*.service; do \
		sudo systemctl stop $$(basename $$f); \
		sudo systemctl disable $$(basename $$f); \
		sudo ln -f -s $$f /etc/systemd/system/$$(basename $$f); \
		sudo systemctl enable $$(basename $$f); \
		sudo systemctl start $$(basename $$f); \
	done
	sudo systemctl daemon-reload
	touch $@

stopService/%:
	-sudo systemctl stop $*
	-sudo systemctl disable $*

stopServices: $(foreach s,$(services),stopService/$(s))
	for f in $$PWD/$(out)/systemd/*.service; do \
		sudo systemctl stop $$(basename $$f); \
		sudo systemctl disable $$(basename $$f); \
		sudo rm /etc/systemd/system/$$(basename $$f); \
	done
	sudo systemctl daemon-reload
	rm $(servicesStarted)


starts += $(servicesStarted)
stops += stopServices
