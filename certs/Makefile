
ca.key:
	openssl genrsa -out ca.key 2048

ca.crt: ca.key Makefile
	openssl req \
		-x509 -new -nodes \
		-key ca.key \
		-subj "/CN=kubi-ca" \
		-days 100000 \
		-out ca.crt


api.key:
	openssl genrsa -out api.key 2048

api.csr: api.key api.conf
	openssl req -new -key api.key -out api.csr -config api.conf

api.crt: api.csr api.conf ca.crt ca.key 
	openssl x509 -req \
		-in api.csr \
		-CA ca.crt -CAkey ca.key \
		-CAcreateserial \
		-days 100000 \
		-extensions v3_ext \
		-extfile api.conf \
		-out api.crt


admin.key:
	openssl genrsa -out admin.key 2048

admin.csr: admin.key admin.conf
	openssl req -new -key admin.key -out admin.csr -config admin.conf

admin.crt: admin.csr admin.conf ca.crt ca.key 
	openssl x509 -req \
		-in admin.csr \
		-CA ca.crt -CAkey ca.key \
		-CAcreateserial \
		-days 100000 \
		-extfile admin.conf \
		-out admin.crt
