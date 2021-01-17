# Module etcHosts

_file:=/etc/hosts

$(_file): host/Makefile
	sudo sed -i '/#kubi/d' $@
	echo "127.0.0.1 kubi #kubi" | sudo tee -a $@
	echo "127.0.0.1 kubi.local #kubi" | sudo tee -a $@

preps += $(_file)

