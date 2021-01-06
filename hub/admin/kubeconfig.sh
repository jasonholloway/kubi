#!/bin/bash -x

publicUrl=kubi
file=admin/kubeconfig
user=admin

kubectl config set-cluster kubi \
	--certificate-authority=ca/crt \
	--embed-certs=true \
	--server=https://${publicUrl}:6443 \
	--kubeconfig=${file}

kubectl config set-credentials ${user} \
	--client-certificate=admin/crt \
	--client-key=admin/key \
	--embed-certs=true \
	--kubeconfig=${file}

kubectl config set-context default \
	--cluster=kubi \
	--user=${user} \
	--kubeconfig=${file}

kubectl config use-context default --kubeconfig=${file}
