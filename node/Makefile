n:=nodes/$(host)
internalIP:=kubi.local

include etcd/Makefile
include k8s/Makefile
include api/Makefile

ca/crt:
	test -f $@

$n/:
	mkdir -p $(n) || true

$n/key: $n/
	openssl genrsa -out $n/key 2048

$n/csr: $n/key
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:nodes/CN=system:nodes:$(host)" \
		-key $n/key \
		-out $n/csr

$n/crt:
	test -f $@

$n/done: $n/crt node/hosts $(etcdService) k8s/done api/done
	cat node/hosts | sudo tee -a /etc/hosts
	touch $@

clean:
	rm -rf $n etcd k8s

