# Module api

_d:=$(dir $(lastword $(MAKEFILE_LIST)))

_serviceTemplate:=$(_d)/kube-api.service.sh
_service:=$(out)/systemd/kube-api.service

encryptionYamlFile:=out/etc/encryption.yaml

# internalIp:=127.0.0.1
# --advertise-address=$(internalIp)


$(_service): $(_serviceTemplate) $(servicePath)/ $(_bin) $(encryptionYamlFile)
	$(_serviceTemplate) \
		$(_bin) \
		$(ca_crt) \
		$(_crt) \
		$(_key) \
		$(encryptionYamlFile) > $@


services += kube-api
serviceFiles += $(_service)
files += $(_service)
