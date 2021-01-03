
nodes:=puce
nodeUrl_puce:=puce.upis
nodeUser_puce:=kubi

nodeTargets:=$(foreach n,$(nodes),nodes/$(n)/prep)
nodeCleans:=$(foreach n,$(nodes),nodes/$(n)/clean)

.PHONY: clean prep certs k8s/prep

prep: certs k8s/prep $(nodeTargets) admin/kubeconfig

certs: ca/crt admin/crt api/crt manager/crt scheduler/crt

include ca/Makefile
include api/Makefile
include k8s/Makefile


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

admin/kubeconfig: ca/crt admin/crt admin/key admin/kubeconfig.sh
	admin/kubeconfig.sh


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
# NODES

syncOut = rsync -rt --exclude 'ca/key' . $(nodeUser_$*)@$(nodeUrl_$*):/kubi
syncIn = rsync -rt --exclude '*key' --exclude '*done' $(nodeUser_$*)@$(nodeUrl_$*):/kubi/nodes .

nodes/%/csr: ca/crt
	$(syncOut)
	ssh $(nodeUser_$*)@$(nodeUrl_$*) "cd /kubi && make -f node/Makefile $@ host=$*"
	$(syncIn)

nodes/%/crt: nodes/%/csr nodes/%/csr.extensions
	openssl x509 -req \
		-CA ca/crt \
		-CAkey ca/key \
		-days 9999 \
		-set_serial 01 \
		-extfile nodes/$*/csr.extensions \
		-in nodes/$*/csr \
		-out $@
	$(syncOut)


nodes/%/prep: nodes/%/crt manager/crt scheduler/crt api/crt k8s/encryption.yaml
	$(syncOut)
	ssh $(nodeUser_$*)@$(nodeUrl_$*) "cd /kubi && make -f node/Makefile --debug $@ host=$*"

nodes/%/clean:
	ssh $(nodeUser_$*)@$(nodeUrl_$*) "cd /kubi; make -f node/Makefile clean host=$*"




###############################################################
# GENERAL

clean: $(nodeCleans) k8s/clean
	rm -rf **/*crt **/*csr nodes


# gruesomely needed to stop deletion of supposedly-intermediate files
.SECONDARY:

