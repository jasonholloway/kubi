h:=out/hosts/$(host)
internalIP:=kubi.local

include $(wildcard k8s/*.mk)
include $(wildcard master/*.mk)
include $(wildcard worker/*.mk)

prep: $h/crt /etc/hosts $(serviceFiles)


ca/crt:
	test -f $@

$h/:
	mkdir -p $h || true

$h/key: $h/
	openssl genrsa -out $h/key 2048

$h/csr.conf $h/csr.extensions: host/csr.conf.sh
	host=$(host) host/csr.conf.sh

$h/csr: $h/key $h/csr.conf
	openssl req -new -nodes \
		-config $h/csr.conf \
		-key $h/key \
		-out $h/csr

$h/crt:
	test -f $@


define etcHosts

\# kubi
127.0.0.1 kubi
127.0.0.1 kubi.local

endef

/etc/hosts: host/Makefile
	echo "$(etcHosts)" | sudo tee -a /etc/hosts


allServices: $(foreach s,$(services),$($(s)ServiceFile))
	-mkdir -p out
	touch out/allServices


test: $(foreach s,$(services),$($(s)Test))


clean: $(foreach s,$(services),$(s)Clean)
	-sudo systemctl daemon-reload
	-sudo rm -rf $h etcd k8s var
