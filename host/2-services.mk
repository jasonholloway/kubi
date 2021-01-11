
reloadServices: $(serviceFiles)
	sudo systemctl daemon-reload


startService/%: reloadServices
	sudo ln -f -s $$PWD/$(out)/systemd/$*.service /etc/systemd/system/$*.service
	sudo systemctl enable $*
	sudo systemctl start $*


startServices: $(foreach s,$(services),startService/$(s)) 
	-mkdir -p out
	touch out/installServices


stopService/%:
	sudo systemctl stop $*
	sudo systemctl disable $*

stopServices: $(foreach s,$(services),stopService/$(s))
	sudo systemctl daemon-reload


starts += startServices
stops += stopServices
