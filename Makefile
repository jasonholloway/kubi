
nodes:=puce.upis
nodeUser:=kubi

nodeDones:=$(foreach n,$(nodes),nodes/$(n)/done)
nodeCleans:=$(foreach n,$(nodes),nodes/$(n)/clean)

done: ca $(nodeDones) certs
	@echo $(nodeDones)
	touch done


certs: admin/crt manager/crt scheduler/crt


###############################################################
# CA

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



###############################################################
# ADMIN

admin/:
	mkdir -p admin || true

admin/key: admin/
	openssl genrsa -out admin/key 2048

admin/csr: admin/key
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:masters/CN=kubi-admin" \
		-key admin/key \
		-out admin/csr

admin/crt: admin/csr
	openssl x509 -req \
		-sha256 \
		-CA ca/crt \
		-CAkey ca/key \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in admin/csr \
		-out admin/crt


###############################################################
# SCHEDULER

scheduler/:
	mkdir -p scheduler || true

scheduler/key: scheduler/
	openssl genrsa -out scheduler/key 2048

scheduler/csr: scheduler/key
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-scheduler/CN=system:kube-scheduler" \
		-key scheduler/key \
		-out scheduler/csr

scheduler/crt: scheduler/csr
	openssl x509 -req \
		-sha256 \
		-CA ca/crt \
		-CAkey ca/key \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in scheduler/csr \
		-out scheduler/crt


###############################################################
# MANAGER

manager/:
	mkdir -p manager || true

manager/key: manager/
	openssl genrsa -out manager/key 2048

manager/csr: manager/key
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:kube-controller-manager/CN=system:kube-controller-manager" \
		-key manager/key \
		-out manager/csr

manager/crt: manager/csr
	openssl x509 -req \
		-sha256 \
		-CA ca/crt \
		-CAkey ca/key \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in manager/csr \
		-out manager/crt



###############################################################
# API

api/:
	mkdir -p api || true

api/key: api/
	openssl genrsa -out api/key 2048

api/csr: api/key
	openssl req -new -nodes \
		-sha256 \
		-subj "/O=system:masters/CN=kubi-api" \
		-key api/key \
		-out api/csr

api/crt: api/csr
	openssl x509 -req \
		-sha256 \
		-CA ca/crt \
		-CAkey ca/key \
		-set_serial 01 \
		-extensions req_ext \
		-days 9999 \
		-in api/csr \
		-out api/crt



###############################################################
# NODES

syncOut = rsync -rt --exclude 'ca/key' . $*:/kubi
syncIn = rsync -rt --exclude '*key' $*:/kubi/nodes .

nodes/%/csr: ca/crt
	$(syncOut)
	ssh $(nodeUser)@$* "cd /kubi && make -f node/Makefile csr host=$*"
	$(syncIn)

nodes/%/crt: nodes/%/csr
	openssl x509 -req \
		-sha256 \
		-CA ca/crt \
		-CAkey ca/key \
		-days 9999 \
		-set_serial 01 \
		-extensions req_ext \
		-in nodes/$*/csr \
		-out $@
	$(syncOut)


nodes/%/done: nodes/%/crt manager/crt scheduler/crt api/crt 
	$(syncOut)
	ssh $(nodeUser)@$* "cd /kubi && make -f node/Makefile $@ host=$*"

nodes/%/clean:
	ssh $(nodeUser)@$* "cd /kubi; make -f node/Makefile clean host=$*"




###############################################################
# GENERAL

clean: $(nodeCleans)
	rm -rf done **/*crt **/*key **/*csr nodes


# gruesomely needed to stop deletion of supposedly-intermediate files
.SECONDARY:
