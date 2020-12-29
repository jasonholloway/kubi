#!/bin/bash

cat <<EOF | sudo tee k8s/kube-scheduler.yaml
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/kubi/var/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF
