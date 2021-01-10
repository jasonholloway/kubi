mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=out/etc/api.key
csrConfFile:=out/etc/api.csr.conf
csrFile:=out/etc/api.csr
crtFile:=out/etc/api.crt

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

$(crtFile): $(csrFile) $(caCrtFile) $(caKeyFile)
	openssl x509 -req \
		-sha256 \
		-CA $(caCrtFile) \
		-CAkey $(caKeyFile) \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in $(csrFile) \
		-out $$@


preps += $(crtFile)
files += $(crtFile)
keyFiles += $(keyFile)

endef

$(eval $(module))
