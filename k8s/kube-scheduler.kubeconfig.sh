#!/bin/bash

cluster=kubi
file=/kubi/var/kube-scheduler.kubeconfig

kubectl config set-cluster ${cluster} \
	--certificate-authority=/kubi/ca/crt \
	--embed-certs=true \
	--server=https://kubi:6443 \
	--kubeconfig=${file}

kubectl config set-credentials system:kube-scheduler \
	--client-certificate=/kubi/scheduler/crt \
	--client-key=/kubi/scheduler/key \
	--embed-certs=true \
	--kubeconfig=${file}

kubectl config set-context default \
	--cluster=${cluster} \
	--user=system:kube-scheduler \
	--kubeconfig=${file}

kubectl config use-context default --kubeconfig=${file}
