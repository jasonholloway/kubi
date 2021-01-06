#!/bin/bash -x

publicUrl=kubi
host=${host:?host not set}
file=/kubi/var/kubelet.kubeconfig
user=system:node:${host}

kubectl config set-cluster kubi \
	--certificate-authority=/kubi/ca/crt \
	--embed-certs=true \
	--server=https://${publicUrl}:6443 \
	--kubeconfig=${file}

kubectl config set-credentials ${user} \
	--client-certificate=/kubi/nodes/${host}/crt \
	--client-key=/kubi/nodes/${host}/key \
	--embed-certs=true \
	--kubeconfig=${file}

kubectl config set-context default \
	--cluster=kubi \
	--user=${user} \
	--kubeconfig=${file}

kubectl config use-context default --kubeconfig=${file}
