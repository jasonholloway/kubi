mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=$(out)/api.key
csrConfFile:=$(out)/api.csr.conf
csrFile:=$(out)/api.csr
crtFile:=$(out)/api.crt

define module

$(keyFile):
	mkdir -p $$(@D)
	openssl genrsa -out $$@ 2048


define csrConf
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


$(csrConfFile):
	mkdir -p $$(@D)
	$$(file > $$@,$$(csrConf))

$(csrFile): $(keyFile) $(csrConfFile)
	openssl req -new -nodes \
		-key $(keyFile) \
		-config $(csrConfFile) \
		-out $$@


apiCrtFile:=$(crtFile)
apiKeyFile:=$(keyFile)

preps += $(csrFile)
files += $(crtFile)
keyFiles += $(keyFile)

endef

$(eval $(module))
