#!/bin/bash

cat <<EOF
{
	"cniVersion": "0.3.1",
	"name": "lo",
	"type": "loopback"
}
EOF
