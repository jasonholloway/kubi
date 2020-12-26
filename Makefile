
nodes = puce.upis

done: ca nodes
	touch done

clean:
	rm -rf **/*crt **/*key nodes/*

ca: ca/key ca/crt

ca/key: 
	openssl genrsa -out ca/key 2048

ca/crt: ca/key Makefile
	openssl req \
		-x509 -new -nodes \
		-key ca/key \
		-subj "/CN=kubi-ca" \
		-days 100000 \
		-out ca/crt

nodes: ca node
	mkdir -p nodes

	for node in $(nodes); do \
		scp -r node $$node:kubi; \
		ssh $$node "cd kubi && make"; \
		touch nodes/$$node; \
	done

	touch nodes

