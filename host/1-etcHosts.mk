etcHostsFile:=/etc/hosts

$(etcHostsFile): host/Makefile
	sudo sed -i '/#kubi/d' $@
	echo "127.0.0.1 kubi #kubi" | sudo tee -a $@
	echo "127.0.0.1 kubi.local #kubi" | sudo tee -a $@

preps += $(etcHostsFile)

