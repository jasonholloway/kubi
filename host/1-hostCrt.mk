# Module host

_key:=$(out)/host.key
_csr:=$(out)/host.csr
_csrConf:=$(out)/host.csr.conf
_csrExt:=$(out)/host.csr.ext
_crt:=$(out)/host.crt

$(_key):
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048


define _csrConfData
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
O = system:nodes
CN = system:node:$(host)
endef 


define _csrExtData
keyUsage = keyEncipherment,dataEncipherment
extendedKeyUsage = serverAuth,clientAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $(host)
endef


$(_csrConf):
	$(file > $@,$(_csrConfData))

$(_csrExt):
	$(file > $@,$(_csrExtData))

$(_csr): $(_key) $(_csrConf) $(_csrExt)
	openssl req -new -nodes \
		-config $(_csrConf) \
		-key $(_key) \
		-out $@

$(_crt):
	[ -f $@ ] || exit 1


preps += $(_csr)
starts += $(_crt)
keyFiles += $(_key)
files += $(_csr) $(_csrConf) $(_csrExt) $(_crt)
