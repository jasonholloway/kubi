keyFile:=$(out)/host.key
csrFile:=$(out)/host.csr
csrConfFile:=$(out)/host.csr.conf
csrExtFile:=$(out)/host.csr.ext
crtFile:=$(out)/host.crt

define module

$(keyFile):
	mkdir -p $$(@D)
	openssl genrsa -out $$@ 2048


define csrConf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
O = system:nodes
CN = system:node:$(host)
endef 


define csrExtConf
keyUsage = keyEncipherment,dataEncipherment
extendedKeyUsage = serverAuth,clientAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $(host)
endef


$(csrConfFile):
	$$(file > $$@,$$(csrConf))

$(csrExtFile):
	$$(file > $$@,$$(csrExtConf))

$(csrFile): $(keyFile) $(csrConfFile) $(csrExtFile)
	openssl req -new -nodes \
		-config $(csrConfFile) \
		-key $(keyFile) \
		-out $$@


$(crtFile):
	[ -f $$@ ] || exit 1


preps += $(csrFile)
starts += $(crtFile)
keyFiles += $(keyFile)
files += $(csrFile) $(csrConfFile) $(csrExtFile) $(crtFile)

endef

$(eval $(module))
