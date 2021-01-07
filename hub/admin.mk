mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile=out/etc/ca.key
crtFile=out/etc/ca.crt
kubeconfigFile:=out/etc/admin.kubeconfig
caCrtFile:=out/etc/ca.crt
caKeyFile:=out/etc/ca.key


$(keyFile): 
	openssl genrsa -out $@ 2048

csr=$(shell \
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:masters/CN=kubi-admin" \
		-key $(keyFile) \
		-out $@)

$(crtFile): $(keyFile) $(caCrtFile) $(caKeyFile)
	openssl x509 -req \
		-sha256 \
		-CA $(caCrtFile) \
		-CAkey $(caKeyFile) \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in <(echo "$(csr)") \
		-out $@

$(kubeconfigFile): $(caCrtFile) $(crtFile) $(keyFile) $(mkFile)
	kubectl config set-cluster kubi \
		--certificate-authority=$(caCrtFile) \
		--embed-certs=true \
		--server=https://kubi:6443 \
		--kubeconfig=$@
	kubectl config set-credentials admin \
		--client-certificate=$(crtFile) \
		--client-key=$(keyFile) \
		--embed-certs=true \
		--kubeconfig=$@
	kubectl config set-context default \
		--cluster=kubi \
		--user=${user} \
		--kubeconfig=$@
	kubectl config use-context default \
		--kubeconfig=$@


files += $(crtFile) $(kubeconfigFile)
keyFiles += $(keyFile)
