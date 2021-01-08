
reloadServices: $(foreach s,$(services),$($(s)ServiceFile))
	systemctl daemon-reload

startService/%: reloadServices
	systemctl enable $*
	systemctl start $*


startServices: $(foreach s,$(services),startService/$(s)) 
	-mkdir -p out
	touch out/installServices


stopService/%:
	systemctl stop $*
	systemctl disable $*

stopServices: $(foreach s,$(services),stopService/$(s))
	systemctl daemon-reload


starts += startServices
stops += stopServices
