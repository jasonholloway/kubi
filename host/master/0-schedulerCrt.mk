mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=$(out)/scheduler.key
csrFile:=$(out)/scheduler.csr
crtFile:=$(out)/scheduler.crt

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


schedulerKeyFile:=$(keyFile)
schedulerCrtFile:=$(crtFile)

preps += $(csrFile)
files += $(crtFile) $(csrFile)
keyFiles += $(keyFile)

endef

$(eval $(module))
