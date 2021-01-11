mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=out/etc/ca.key
crtConfFile:=out/etc/ca.crt.conf
crtFile:=out/etc/ca.crt

define module


define caCrtConf
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
	$$(file > $$@,$$(caCrtConf))

$(crtFile): $(keyFile) $(crtConfFile)
	openssl req \
		-config $(crtConfFile) \
		-x509 -new -nodes \
		-key $(keyFile) \
		-days 100000 \
		-out $$@

signCerts: $(keyFile) $(crtFile)
	find out/hosts -name '*csr' \
	| while read f; do \
			openssl x509 -req \
				-CA $(crtFile) \
				-CAkey $(keyFile) \
				-set_serial 01 \
				-days 9999 \
				$$$$([ -f $$$$f.ext ] && echo "-extfile $$$$f.ext" ) \
				-in $$$$f \
				-out $$$${f%.*}.crt; \
		done


caKeyFile:=$(keyFile)
caCrtFile:=$(crtFile)

preps += $(crtFile)
postPreps += signCerts

files += $(crtFile)
keyFiles += $(keyFile)


endef

$(eval $(module))
