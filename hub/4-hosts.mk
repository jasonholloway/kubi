hosts:=puce
puce_url:=puce.upis
puce_user:=kubi

remoteRoot:=/kubi
caCrtFile:=out/etc/ca.crt


define perHostOuter

root:=out/hosts/$(h)
prepped:=$$(root)/prepped
started:=$$(root)/started
clean:=$$(root)/clean
crtFile:=out/etc/$(h).crt
csrFile:=out/etc/$(h).csr
csrExtFile:=out/etc/$(h).csr.ext

sshHost:=$($(h)_user)@$($(h)_url)
syncOut:=rsync -rplt -F . $$(sshHost):$(remoteRoot)/
syncIn:=rsync -rplt -F $$(sshHost):$(remoteRoot)/ .
ssh=ssh $$(sshHost) "cd $(remoteRoot) && make -d host=$(h) -f host/Makefile $(1)"

$$(eval $$(perHostInner))
endef


define perHostInner

$(prepped): $(caCrtFile)
	mkdir -p $$(@D)
	$(syncOut)
	$(call ssh,prep)
	$(syncIn)


$(started): $(crtFile)
	mkdir -p $$(@D)
	$(syncOut)
	$(call ssh,start)
	$(syncIn)


$(clean):
	$(call ssh,clean)
	rm -rf $(root)


$(crtFile): $(csrFile) $(csrExtFile)
	openssl x509 -req \
		-CA $(caCrtFile) \
		-CAkey $(caKeyFile) \
		-days 9999 \
		-set_serial 01 \
		-extfile $(csrExtFile) \
		-in $(csrFile) \
		-out $$@

files += $(crtFile) $(prepped) $(started)
preps += $(prepped)
starts += $(started)
cleans += $(clean)

endef

$(foreach h,$(hosts),$(eval $(perHostOuter)))
