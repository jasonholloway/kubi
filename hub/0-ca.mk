mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
caKeyFile=out/etc/ca.key
caCrtFile=out/etc/ca.crt


define crtConf
[req]
default_bits			 = 2048
x509_extensions		 = v3_ca
distinguished_name = dn
prompt = no

[dn]
CN = kubi-ca

[v3_ca]
basicConstraints				= critical, CA:TRUE
subjectKeyIdentifier		= hash
authorityKeyIdentifier	= keyid:always, issuer:always
keyUsage								= critical, cRLSign, digitalSignature, keyCertSign, keyEncipherment
extendedKeyUsage				= serverAuth, clientAuth
endef


$(caKeyFile): 
	openssl genrsa -out $@ 2048

$(caCrtFile): $(caKeyFile) $(mkFile)
	openssl req \
		-config <(echo "$(crtConf)") \
		-x509 -new -nodes \
		-key $(caKeyFile) \
		-days 100000 \
		-out $@


files += $(caCrtFile)
keyFiles += $(caKeyFile)
