# Module admin

_key:=out/etc/admin.key
_csr:=out/etc/admin.csr
_crt:=out/etc/admin.crt
_kubeconfig:=out/etc/admin.kubeconfig

$(_key): 
	mkdir -p $(@D)
	openssl genrsa -out $@ 2048

$(_csr): $(_key)
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:masters/CN=kubi-admin" \
		-key $(_key) \
		-out $@

$(_crt): $(_csr) $(ca_crt) $(ca_key)
	openssl x509 -req \
		-sha256 \
		-CA $(ca_crt) \
		-CAkey $(ca_key) \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in $(_csr) \
		-out $@

$(_kubeconfig): $(ca_crt) $(_crt) $(_key) $(me)
	kubectl config set-cluster kubi \
		--certificate-authority=$(ca_crt) \
		--embed-certs=true \
		--server=https://kubi:6443 \
		--kubeconfig=$@
	kubectl config set-credentials admin \
		--client-certificate=$(_crt) \
		--client-key=$(_key) \
		--embed-certs=true \
		--kubeconfig=$@
	kubectl config set-context default \
		--cluster=kubi \
		--user=admin \
		--kubeconfig=$@
	kubectl config use-context default \
		--kubeconfig=$@


preps += $(_kubeconfig)
files += $(_crt) $(_kubeconfig)
keyFiles += $(_key)
