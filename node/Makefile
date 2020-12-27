n:=nodes/$(host)
internalIP:=127.0.0.1

csr: $n/csr
crt: $n/crt

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

$n/done: $n/crt etcd/done k8s/done
	touch done

include etcd/Makefile
include k8s/Makefile

clean:
	rm -rf $n

