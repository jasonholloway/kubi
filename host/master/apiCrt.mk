mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))

out:=out/etc
keyFile:=$(out)/api.key
csrFile:=$(out)/api.csr
crtFile:=$(out)/api.crt


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


$(keyFile):
	openssl genrsa -out $@ 2048

$(csrFile): $(keyFile) $(mkFile)
	openssl req -new \
		-config <(echo "$(csrConf)") \
		-key $(keyFile) \
		-out $@

$(crtFile): $(csrFile)
	openssl x509 -req \
		-sha256 \
		-CA $(caCrtFile) \
		-CAkey $(caKeyFile) \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in $(csrFile) \
		-out $@


keyFiles += $(keyFile)
files += $(crtFile) $(csrFile)
