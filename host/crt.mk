caCrtFile:=out/etc/ca.crt
hostKeyFile:=out/etc/$(host).key
hostCsrFile:=out/etc/$(host).csr
hostCsrExtFile:=out/etc/$(host).csr.ext
hostCrtFile:=out/etc/$(host).crt


$(caCrtFile):
	test -f $@

$(hostKeyFile):
	mkdir -p $(@D)
	echo BIG POO $$(hostname) >&2
	openssl genrsa -out $@ 2048


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


export csrConf
$(hostCsrFile): $(hostKeyFile) $(hostCsrExtFile)
	openssl req -new -nodes \
		-config <(echo "$$csrConf") \
		-key $(hostKeyFile) \
		-out $@

$(hostCsrExtFile):
	$(file > $@,$(csrExtConf))

$(hostCrtFile):
	test -f $@


keyFiles += $(hostKeyFile)
files += $(hostCsrFile) $(hostCsrExtFile) $(hostCrtFile)
