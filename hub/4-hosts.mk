hosts:=puce
puce_url:=puce.upis
puce_user:=kubi

remoteRoot:=/kubi
syncOut=rsync -rt --exclude 'ca/key' . $($*_user)@$($*_url):$(remoteRoot)
syncIn=rsync -rt --exclude '*key' --exclude '*done' $($*_user)@$($*_url):$(remoteRoot)/$(h) .


prepHost/%: $(caCrtFile)
	$(syncOut)
	ssh $($*_user)@$($*_url) "cd $(remoteRoot) && make -f host/Makefile prep host=$*"
	$(syncIn)


startHost/%: out/etc/%.crt
	$(syncOut)
	ssh $($*_user)@$($*_url) "cd $(remoteRoot) && make -f host/Makefile start host=$*"
	$(syncIn)


cleanHost/%:
	$(syncOut)
	ssh $($*_user)@$($*_url) "cd $(remoteRoot) && make -f host/Makefile clean host=$*"
	$(syncIn)



preps += $(foreach h,$(hosts),prepHost/$(h))
starts += $(foreach h,$(hosts),startHost/$(h))
cleans += $(foreach h,$(hosts),cleanHost/$(h))


out/etc/%.crt: out/etc/%.csr out/etc/%.csr.ext
	openssl x509 -req \
		-CA $(caCrtFile) \
		-CAkey $(caKeyFile) \
		-days 9999 \
		-set_serial 01 \
		-extfile out/etc/$*.csr.ext \
		-in out/etc/$*.csr \
		-out $@

