
reloadServices: $(foreach s,$(services),$($(s)ServiceFile))
	sudo systemctl daemon-reload

startService/%: reloadServices
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
