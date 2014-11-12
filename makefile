.PHONY: all
all: libwebsockets-canopy libred-canopy libcanopy

.PHONY: libwebsockets-canopy
libwebsockets-canopy:
	mkdir -p _out/libwebsockets
	cd _out/libwebsockets && cmake -DLWS_USE_IPV6=0 ../../../3rdparty/libwebsockets
	make -C _out/libwebsockets

.PHONY: libred-canopy
libred-canopy:
	mkdir -p _out/libred
	make -C ../3rdparty/libred
	mv ../3rdparty/libred/libred.so _out/libred/libred-canopy.so

.PHONY: libcanopy
libcanopy:
	mkdir -p _out/libcanopy
	make -C ../libcanopy
	mv ../libcanopy/libcanopy/libcanopy.so _out/libcanopy/libcanopy.so

