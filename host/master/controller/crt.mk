# Module controller

_key:=$(out)/controller.key
_csr:=$(out)/controller.csr
_crt:=$(out)/controller.crt


$(_key):
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048

$(_csr): $(_key)
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-controller-manager/CN=system:kube-controller-manager" \
		-key $(_key) \
		-out $@


preps += $(_csr)
files += $(_crt) $(_csr)
keyFiles += $(_key)

