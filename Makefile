
nodes = puce.upis
nodeDones = $(foreach n,$(nodes),nodes/$(n)/done)
nodeCleans = $(foreach n,$(nodes),nodes/$(n)/clean)

done: ca $(nodeDones)
	@echo $(nodeDones)
	touch done


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


syncOut = rsync -rt --exclude '*key' ca node $*:kubi
syncIn = rsync -rt --exclude '*key' $*:kubi/nodes .

nodes/%/csr: ca/crt
	$(syncOut)
	ssh $* "cd kubi && make -f node/Makefile csr host=$*"
	$(syncIn)

nodes/%/crt: nodes/%/csr
#here we process the csr and sync back to node
	echo PLOPS > $@
	$(syncOut)

nodes/%/done: nodes/%/crt
	echo DONE?

nodes/%/clean:
	ssh $* "if [ -d kubi ]; then cd kubi; make -f node/Makefile clean host=$*; cd ..; rm -rf kubi; fi"


clean: $(nodeCleans)
	rm -rf done **/*crt **/*key **/*csr nodes


#.PHONY: clean $(nodeCleans)


# gruesomely needed to stop deletion of supposedly-intermediate files
.SECONDARY:
