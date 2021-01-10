mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=out/etc/ca.key
crtConfFile:=out/etc/ca.crt.conf
crtFile:=out/etc/ca.crt

define module


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


$(keyFile): 
	mkdir -p $$(@D)
	openssl genrsa -out $$@ 2048

$(crtConfFile):
	$$(file > $$@,$$(crtConf))

$(crtFile): $(keyFile) $(crtConfFile)
	openssl req \
		-config $(crtConfFile) \
		-x509 -new -nodes \
		-key $(keyFile) \
		-days 100000 \
		-out $$@


caKeyFile:=$(keyFile)
caCrtFile:=$(crtFile)

files += $(crtFile)
keyFiles += $(keyFile)


endef

$(eval $(module))
