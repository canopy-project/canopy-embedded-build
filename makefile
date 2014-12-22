.PHONY: all
all: libwebsockets-canopy libred-canopy libcanopy libsddl
	@echo
	@echo "*********************************************************"
	@echo "* SUCCESS!                                              *"
	@echo "*********************************************************"


.PHONY: libwebsockets-canopy
libwebsockets-canopy:
	mkdir -p _out/lib
	mkdir -p _out/intermediate/libwebsockets
	cd _out/intermediate/libwebsockets && cmake -DLWS_USE_IPV6=0 ../../../../3rdparty/libwebsockets
	make -C _out/intermediate/libwebsockets
	mv _out/intermediate/libwebsockets/lib/libwebsockets-canopy.* _out/lib/

.PHONY: libred-canopy
libred-canopy:
	mkdir -p _out/lib
	make -C ../3rdparty/libred
	mv ../3rdparty/libred/libred.so _out/lib/libred-canopy.so

.PHONY: libsddl
libsddl:
	mkdir -p _out/lib
	make -C ../libsddl
	mv ../libsddl/libsddl.so _out/lib/libsddl.so


.PHONY: libcanopy
libcanopy:
	mkdir -p _out/lib
	make -C ../libcanopy
	mv ../libcanopy/libcanopy.so _out/lib/libcanopy.so

