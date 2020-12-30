host=${host:?host not specified}

cat <<EOF > nodes/${host}/csr.conf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
O = system:nodes
CN = system:node:${host}

EOF

cat <<EOF > nodes/${host}/csr.extensions
keyUsage = keyEncipherment,dataEncipherment
extendedKeyUsage = serverAuth,clientAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${host}

EOF
