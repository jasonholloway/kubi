mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile=out/etc/ca.key
crtFile=out/etc/ca.crt


define crtConf
[req]
default_bits       = 2048
x509_extensions    = v3_ca
distinguished_name = dn
prompt = no

[dn]
CN = kubi-ca

[v3_ca]
basicConstraints        = critical, CA:TRUE
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid:always, issuer:always
keyUsage                = critical, cRLSign, digitalSignature, keyCertSign, keyEncipherment
extendedKeyUsage        = serverAuth, clientAuth
endef


$(keyFile): 
	openssl genrsa -out $@ 2048

$(crtFile): $(keyFile) $(mkFile)
	openssl req \
		-config <(echo "$(crtConf)") \
		-x509 -new -nodes \
		-key $(keyFile) \
		-days 100000 \
		-out $@


files += $(crtFile)
keyFiles += $(keyFile)
