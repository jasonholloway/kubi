# Module scheduler

_key:=$(out)/scheduler.key
_csr:=$(out)/scheduler.csr
_crt:=$(out)/scheduler.crt

$(_key):
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048

$(_csr): $(_key)
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-scheduler/CN=system:kube-scheduler" \
		-key $(_key) \
		-out $@


preps += $(_csr)
files += $(_crt) $(_csr)
keyFiles += $(_key)
