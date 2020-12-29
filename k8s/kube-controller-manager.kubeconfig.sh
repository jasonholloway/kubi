#!/bin/bash

cluster=kubi
file=/kubi/var/kube-controller-manager.kubeconfig

kubectl config set-cluster ${cluster} \
	--certificate-authority=/kubi/ca/crt \
	--embed-certs=true \
	--server=https://kubi:6443 \
	--kubeconfig=${file}

kubectl config set-credentials system:kube-controller-manager \
	--client-certificate=/kubi/manager/crt \
	--client-key=/kubi/manager/key \
	--embed-certs=true \
	--kubeconfig=${file}

kubectl config set-context default \
	--cluster=${cluster} \
	--user=system:kube-controller-manager \
	--kubeconfig=${file}

kubectl config use-context default --kubeconfig=${file}

