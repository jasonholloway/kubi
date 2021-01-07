
hosts:=puce
puce_url:=puce.upis
puce_user:=kubi

hostTargets:=$(foreach h,$(hosts),out/hosts/$(h)/prep)
nodeCleans:=$(foreach h,$(hosts),out/hosts/$(h)/clean)

.PHONY: clean prep certs k8s/prep

prep: certs k8s/prep $(hostTargets) admin/kubeconfig

certs: ca/crt admin/crt api/crt manager/crt scheduler/crt

include hub/ca/Makefile

include api/Makefile
include k8s/Makefile




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
# HOSTS

h:=out/hosts
remoteRoot:=/kubi

syncOut = rsync -rt --exclude 'ca/key' . $($*_user)@$($*_url):$(remoteRoot)
syncIn = rsync -rt --exclude '*key' --exclude '*done' $($*_user)@$($*_url):$(remoteRoot)/$(h) .

$(h)/%/:
	mkdir -p $@

$(h)/%/csr $(h)/%/csr.extensions: $(h)/%/ ca/crt
	$(syncOut)
	ssh $($*_user)@$($*_url) "cd $(remoteRoot) && make -f host/Makefile $@ host=$*"
	$(syncIn)

$(h)/%/crt: $(h)/%/csr $(h)/%/csr.extensions
	openssl x509 -req \
		-CA ca/crt \
		-CAkey ca/key \
		-days 9999 \
		-set_serial 01 \
		-extfile $(h)/$*/csr.extensions \
		-in $(h)/$*/csr \
		-out $@
	$(syncOut)


$(h)/%/prep: $(h)/%/crt manager/crt scheduler/crt api/crt k8s/encryption.yaml
	$(syncOut)
	ssh $(nodeUser_$*)@$(nodeUrl_$*) "cd $(remoteRoot) && make -f host/Makefile --debug $@ host=$*"

$(h)/%/clean:
	ssh $(nodeUser_$*)@$(nodeUrl_$*) "cd $(remoteRoot); make -f host/Makefile clean host=$*"




###############################################################
# GENERAL

clean: $(nodeCleans) k8s/clean
	rm -rf **/*crt **/*csr $(h)


# gruesomely needed to stop deletion of supposedly-intermediate files
.SECONDARY:

