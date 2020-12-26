
n = nodes/$(host)

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
	echo woo

clean:
	rm -rf $n

