mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile=out/etc/schduler.key
crtFile=out/etc/scheduler.crt

$(keyFile):
	openssl genrsa -out $@ 2048

csr=$(shell \
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-scheduler/CN=system:kube-scheduler" \
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

files += $(crtFile)
keyFiles += $(keyFile)
