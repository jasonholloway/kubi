
k8s/encryption.key:
	head -c 32 /dev/urandom | base64 > k8s/encryption.key

k8s/encryption.yaml: k8s/encryption.yaml.sh k8s/encryption.key
	k8s/encryption.yaml.sh



k8s/prep: k8s/encryption.yaml

k8s/clean:
	rm k8s/*.key
	rm k8s/*.yaml


