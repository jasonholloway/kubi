hosts:=puce.upis

remoteRoot:=/kubi
caCrtFile:=out/etc/ca.crt


define perHostOuter

root:=out/hosts/$(h)
crtFile:=out/etc/$(h).crt
csrFile:=out/etc/$(h).csr
csrExtFile:=out/etc/$(h).csr.ext

sshHost:=kubi@$(h)
syncOut:=rsync -rplt -F . $$(sshHost):$(remoteRoot)/
syncIn:=rsync -rplt -F $$(sshHost):$(remoteRoot)/ .
ssh=ssh $$(sshHost) "cd $(remoteRoot) && make -d -f host/Makefile $$(1)"

$$(eval $$(perHostInner))
endef


define perHostInner

prep_$(h): $(caCrtFile)
	$(syncOut)
	$(call ssh,prep)
	$(syncIn)

postPrep_$(h): signCerts
	$(syncOut)

start_$(h):
	$(syncOut)
	$(call ssh,start)
	$(syncIn)


clean_$(h):
	$(call ssh,clean)
	rm -rf $(root)


preps += prep_$(h)
postPreps += postPrep_$(h)
starts += start_$(h)
cleans += clean_$(h)

endef

$(foreach h,$(hosts),$(eval $(perHostOuter)))