#!/bin/bash

encryptionKey="$(<k8s/encryption.key)"

cat <<EOF > k8s/encryption.yaml
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${encryptionKey}
      - identity: {}
EOF

