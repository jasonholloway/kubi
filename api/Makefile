
api/key:
	openssl genrsa -out api/key 2048

api/csr: api/key
	openssl req -new \
		-config api/csr.conf \
		-key api/key \
		-out api/csr

api/crt: api/csr
	openssl x509 -req \
		-sha256 \
		-CA ca/crt \
		-CAkey ca/key \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in api/csr \
		-out api/crt


