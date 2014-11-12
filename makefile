.PHONY: libwebsockets-canopy
libwebsockets-canopy:
	mkdir -p _out/libwebsockets
	cd _out/libwebsockets && cmake -DLWS_USE_IPV6=0 ../../../3rdparty/libwebsockets
	make -C _out/libwebsockets


