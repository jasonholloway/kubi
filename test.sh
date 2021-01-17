#!/bin/bash

caCrtFile() { echo "/kubi/out/etc/ca.crt"; }
apiCrtFile() { echo "/kubi/out/hosts/puce/api.crt"; }
apiKeyFile() { echo "/kubi/out/hosts/puce/api.key"; }
encryptionYamlFile() { echo "/kubi/out/etc/encryption.yaml"; }
abspath() { echo "$@"; }


bin/kube-apiserver \
  --authorization-mode=Node,RBAC \
	    --allow-privileged=true \
	      --apiserver-count=1 \
	        --audit-log-maxage=30 \
		  --audit-log-maxbackup=3 \
		    --audit-log-maxsize=100 \
		      --audit-log-path=/var/kubi/log/audit.log \
		        --bind-address=0.0.0.0 \
			  --client-ca-file=$(abspath $(caCrtFile)) \
			    --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
			      --etcd-cafile=$(abspath $(caCrtFile)) \
			        --etcd-certfile=$(abspath $(apiCrtFile)) \
				  --etcd-keyfile=$(abspath $(apiKeyFile)) \
				    --etcd-servers=https://kubi:2379 \
				      --event-ttl=1h \
				        --encryption-provider-config=$(encryptionYamlFile) \
					  --kubelet-certificate-authority=$(abspath $(caCrtFile)) \
					    --kubelet-client-certificate=$(abspath $(apiCrtFile)) \
					      --kubelet-client-key=$(abspath $(apiKeyFile)) \
					        --kubelet-https=true \
						  --runtime-config='api/all=true' \
						    --service-account-key-file=$(abspath $(apiKeyFile)) \
						      --service-cluster-ip-range=10.32.0.0/24 \
						        --service-node-port-range=30000-32767 \
							  --tls-cert-file=$(abspath $(apiCrtFile)) \
							    --tls-private-key-file=$(abspath $(apiKeyFile)) \
							      --v=2                                                                                                                       




