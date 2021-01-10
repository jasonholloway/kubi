mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=out/etc/scheduler.key
csrFile:=out/etc/scheduler.csr
crtFile:=out/etc/scheduler.crt

define module

$(keyFile):
	mkdir -p $$(@D)
	openssl genrsa -out $$@ 2048

$(csrFile): $(keyFile)
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-scheduler/CN=system:kube-scheduler" \
		-key $(keyFile) \
		-out $$@

$(crtFile): $(csrFile) $$(caCrtFile) $$(caKeyFile)
	openssl x509 -req \
		-sha256 \
		-CA $$(caCrtFile) \
		-CAkey $$(caKeyFile) \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in $(csrFile) \
		-out $$@


preps += $(crtFile)
files += $(crtFile) $(csrFile)
keyFiles += $(keyFile)

endef

$(eval $(module))
