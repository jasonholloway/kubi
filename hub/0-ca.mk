# Module ca

_key:=out/etc/ca.key
_crtConf:=out/etc/ca.crt.conf
_crt:=out/etc/ca.crt

define _crtConfData
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
keyUsage								= critical, cRLSign, digitalSignature, keyCertSign
endef

$(_key): 
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048

$(_crtConf):
	$(file > $@,$(_crtConfData))

$(_crt): $(_key) $(_crtConf)
	openssl req \
		-config $(_crtConf) \
		-x509 -new -nodes \
		-key $(_key) \
		-days 100000 \
		-out $@

_signCerts: $(_key) $(_crt)
	find out/hosts -name '*csr' \
	| while read f; do \
			openssl x509 -req \
				-CA $(_crt) \
				-CAkey $(_key) \
				-set_serial 01 \
				-days 9999 \
				$$([ -f $$f.ext ] && echo "-extfile $$f.ext" ) \
				-in $$f \
				-out $${f%.*}.crt; \
		done


preps += $(_crt)
postPreps += _signCerts

files += $(_crt)
keyFiles += $(_key)
