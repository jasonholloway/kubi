n:=nodes/$(host)
internalIP:=kubi.local

include node/etcd.mk
include node/oci.mk
include node/k8s.mk

ca/crt:
	test -f $@

$n/:
	mkdir -p $(n) || true

$n/key: $n/
	openssl genrsa -out $n/key 2048

$n/csr.conf $n/csr.extensions: node/csr.conf.sh
	host=$(host) node/csr.conf.sh

$n/csr: $n/key $n/csr.conf
	openssl req -new -nodes \
		-config $n/csr.conf \
		-key $n/key \
		-out $n/csr

$n/crt:
	test -f $@

/etc/hosts: node/hosts
	cat node/hosts | sudo tee -a /etc/hosts


$n/prep: $n/crt /etc/hosts $(etcdServiceFile) $(apiServiceFile) $(controllerServiceFile) $(schedulerServiceFile) $(containerdServiceFile) $(kubeletServiceFile)


clean:
	-sudo systemctl stop $(etcdService)
	-sudo systemctl stop $(apiService)
	-sudo systemctl stop $(controllerService)
	-sudo systemctl stop $(schedulerService)
	-sudo systemctl stop $(kubeletService)
	-sudo systemctl disable $(etcdService)
	-sudo systemctl disable $(apiService)
	-sudo systemctl disable $(controllerService)
	-sudo systemctl disable $(schedulerService)
	-sudo systemctl disable $(kubeletService)
	-sudo rm -f $(etcdServiceFile)
	-sudo rm -f $(apiServiceFile)
	-sudo rm -f $(controllerServiceFile)
	-sudo rm -f $(schedulerServiceFile)
	-sudo rm -f $(kubeletServiceFile)
	-sudo systemctl daemon-reload
	-sudo rm -rf $n etcd k8s var

.PHONY: $n/prep
