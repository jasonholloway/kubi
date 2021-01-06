services += api

apiServiceSh:=k8s/kube-api.service.sh
apiServiceFile:=/etc/systemd/system/kube-api.service

dir:=master/api

$(apiServiceFile): $(apiBin) $(apiServiceSh) k8s/encryption.yaml
	host=$(host) internalIP=kubi $(apiServiceSh)

apiTest:

apiClean:
	-sudo systemctl stop kube-api
	-sudo systemctl disable kube-api
	-rm -rf $(apiServiceFile)
