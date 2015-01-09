ifneq ($(CANOPY_EDK_ENVSETUP),1)
    $(error You must first run "source envsetup.sh")
endif

.PHONY: all
all: libwebsockets-canopy libred-canopy libcanopy libsddl
	@echo
	@echo "*********************************************************"
	@echo "* SUCCESS!                                              *"
	@echo "*********************************************************"

ifeq ($(CANOPY_CROSS_COMPILE),1)
    LWSTOOLCHAIN := -DLWS_WITHOUT_EXTENSIONS=1 -DLWS_WITH_SSL=0 -DCMAKE_TOOLCHAIN_FILE=../../../../3rdparty/libwebsockets/canopy-cross-compile.cmake
endif

.PHONY: clean
clean:
	rm -r _out

.PHONY: libwebsockets-canopy
libwebsockets-canopy:
	mkdir -p _out/include
	mkdir -p _out/lib
	mkdir -p _out/intermediate/libwebsockets
	cd _out/intermediate/libwebsockets && cmake -DLWS_IPV6=0 $(LWSTOOLCHAIN) ../../../../3rdparty/libwebsockets
	make -C _out/intermediate/libwebsockets
	mv _out/intermediate/libwebsockets/lib/libwebsockets-canopy.* _out/lib/
	cp ../3rdparty/libwebsockets/lib/libwebsockets.h _out/include

.PHONY: libred-canopy
libred-canopy:
	mkdir -p _out/lib
	make -C ../3rdparty/libred
	mv ../3rdparty/libred/libred.so _out/lib/libred-canopy.so
	cp ../3rdparty/libred/include/* _out/include
	cp ../3rdparty/libred/include/* _out/include
	cp ../3rdparty/libred/under_construction/*.h _out/include

.PHONY: libsddl
libsddl:
	mkdir -p _out/lib
	make -C ../libsddl
	mv ../libsddl/libsddl.so _out/lib/libsddl.so
	cp ../libsddl/include/*.h _out/include


.PHONY: libcanopy
libcanopy:
	mkdir -p _out/lib
	make -C ../libcanopy
	mv ../libcanopy/libcanopy.so _out/lib/libcanopy.so
	cp ../libcanopy/include/*.h _out/include

.PHONY: install
install:
	mkdir -p /usr/local/lib
	mkdir -p /usr/local/include
	cp _out/lib/* /usr/local/lib
	cp _out/include/* /usr/local/include
