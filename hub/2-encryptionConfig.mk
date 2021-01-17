# Module encrypt

_me:=$(abspath $(lastword $(MAKEFILE_LIST)))
_key:=out/etc/encryption.key
_config:=out/etc/encryption.yaml

$(_key):
	mkdir -p $(@D)
	head -c 32 /dev/urandom | base64 > $@

define _configData
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: $(shell cat $(_key))
      - identity: {}
endef


$(_config): $(_key) $(_me)
	$(file > $@,$(_configData))


preps += $(_config)
files += $(_config)
keyFiles += $(_key)
