mkFile:=$(abspath $(lastword $(MAKEFILE_LIST)))
keyFile:=out/etc/encryption.key
yamlFile:=out/etc/encryption.yaml

define module

$(keyFile):
	mkdir -p $$(@D)
	head -c 32 /dev/urandom | base64 > $$@

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
              secret: $$(shell cat $$(keyFile))
      - identity: {}
endef


$(yamlFile): $(keyFile) $(mkFile)
	$$(file > $$@,$$(yaml))


preps += $(yamlFile)
files += $(yamlFile)
keyFiles += $(keyFile)

endef

$(eval $(module))
