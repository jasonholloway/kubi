
ca/key: 
	openssl genrsa -out ca/key 2048

ca/crt: ca/key ca/crt.conf
	openssl req \
		-config ca/crt.conf \
		-x509 -new -nodes \
		-key ca/key \
		-days 100000 \
		-out ca/crt
