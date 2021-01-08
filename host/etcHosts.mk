define etcHosts

127.0.0.1 kubi				 \#kubi
127.0.0.1 kubi.local	 \#kubi

endef

/etc/hosts: host/Makefile
	sed '/#kubi/d' /etc/hosts
	$(file >> $@,$(etcHosts))


