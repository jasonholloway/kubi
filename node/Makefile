
n = nodes/$(host)
bin = /usr/local/bin

csr: $n/csr
crt: $n/crt
install: $n/installed

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



$n/installed: $bin/kubectl
	touch $n/installed

$bin/kubectl:
	wget https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl
	chmod +x kubectl
	mv kubectl $bin/




clean:
	rm -rf $n

