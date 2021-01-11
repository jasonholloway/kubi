mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=$(out)/controller.key
csrFile:=$(out)/controller.csr
crtFile:=$(out)/controller.crt

define module


$(keyFile):
	mkdir -p $$(@D)
	openssl genrsa -out $$@ 2048

$(csrFile): $(keyFile)
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-controller-manager/CN=system:kube-controller-manager" \
		-key $(keyFile) \
		-out $$@


controllerCrtFile:=$(crtFile)

preps += $(csrFile)
files += $(crtFile) $(csrFile)
keyFiles += $(keyFile)

endef

$(eval $(module))
