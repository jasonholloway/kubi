
n = nodes/$(host)
bin = /usr/local/bin
kubeBins=kubelet kube-apiserver kube-controller-manager kube-scheduler
kubeBinPaths=$(foreach n,$(kubeBins),$(bin)/$(n))
etcdBinPath=$(bin)/etcd

csr: $n/csr
crt: $n/crt
install: $(etcdBinPath) $(kubeBinPaths)

ca/crt:
	test -f $@

$n/:
	mkdir -p $(n) || true

$n/key: $n/
	openssl genrsa -out $n/key 2048

$n/csr: $n/key
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:nodes/CN=system:nodes:$(host)" \
		-key $n/key \
		-out $n/csr

$n/crt:
	echo woo


$(etcdBinPath): etcd/version
	./get-etcd.sh

$(kubeBinPaths): kube/version
	./get-kube.sh


clean:
	rm -rf $n

