caCrtFile:=out/etc/ca.crt

$(caCrtFile):
	[ -f $(caCrtFile) ] || exit 1
