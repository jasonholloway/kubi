
ca.key:
	openssl genrsa -out ca.key 2048

ca.crt: ca.key Makefile
	openssl req \
    -x509 -new -nodes \
		-key ca.key \
		-subj "/CN=kubi-ca" \
		-days 100000 \
		-out ca.crt

