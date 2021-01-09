mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=out/etc/encryption.key

$(keyFile):
	mkdir -p $(@D)
	head -c 32 /dev/urandom | base64 > $@


define yaml
kind: EncryptionConfig
apiVersion: v1
resources:
	- resources:
			- secrets
		providers:
			- aescbc:
					keys:
						- name: key1
							secret: $(key)
			- identity: {}
endef

yamlFile:=out/etc/encryption.yaml

$(yamlFile): key=$(file < $(keyFile))
$(yamlFile): $(keyFile) $(mkFile)
	$(file > $@,$(yaml))


files += $(yamlFile)
keyFiles += $(keyFile)
