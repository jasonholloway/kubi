#!/bin/bash
podCidr=$1

cat <<EOF
{
	"cniVersion": "0.3.1",
	"name": "bridge",
	"type": "bridge",
	"bridge": "cnio0",
	"isGateway": true,
	"ipMasq": true,
	"ipam": {
		"type": "host-local",
		"ranges": [
			[{"subnet": "${podCidr}"}]
		],
		"routes": [{"dst": "0.0.0.0/0"}]
	}
}
EOF
