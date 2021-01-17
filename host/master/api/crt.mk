# Module api

_me:=$(abspath $(lastword $(MAKEFILE_LIST)))

_key:=$(out)/api.key
_csrConf:=$(out)/api.csr.conf
_csr:=$(out)/api.csr
_crt:=$(out)/api.crt


define _csrConfData
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[dn]
O=system:masters
CN=kubi

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = kubi
DNS.2 = kubi.local
DNS.3 = puce
DNS.4 = puce.upis
endef


$(_key):
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048

$(_csrConf): $(_me)
	mkdir -p $(@D)
	$(file > $@,$(_csrConfData))

$(_csr): $(_key) $(_csrConf)
	openssl req -new -nodes \
		-key $(_key) \
		-config $(_csrConf) \
		-out $@


preps += $(_csr)
files += $(_crt)
keyFiles += $(_key)
