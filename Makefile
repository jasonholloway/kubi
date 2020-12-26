
nodes = puce.upis
nodeTargets = $(foreach n,$(nodes),nodes/$(n))

done: ca $(nodeTargets)
	touch done

clean:
	rm -rf **/*crt **/*key nodes/*

ca: ca/key ca/crt

ca/key: 
	openssl genrsa -out ca/key 2048

ca/crt: ca/key
	openssl req \
		-x509 -new -nodes \
		-key ca/key \
		-subj "/CN=kubi-ca" \
		-days 100000 \
		-out ca/crt

nodes/%: ca/crt
	scp -r node $*:kubi
	scp ca/crt $*:kubi/ca.crt
	ssh $* "cd kubi && make"
	touch $@


#
# we want csrs to be 
#
#
#
#
#
#
