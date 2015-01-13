ifneq ($(CANOPY_EDK_ENVSETUP),1)
    $(error You must first run "source envsetup.sh")
endif

BUILD_NAME := $(CANOPY_EDK_PLATFORM)_$(CANOPY_EDK_FLAVOR)
BUILD_OUTDIR := $(CANOPY_EMBEDDED_ROOT)/build/_out/$(BUILD_NAME)

.PHONY: all
all: libwebsockets-canopy libred-canopy libcanopy libsddl
	@echo
	@echo "*********************************************************"
	@echo "* SUCCESS!                                              *"
	@echo "*********************************************************"

ifeq ($(CANOPY_CROSS_COMPILE),1)
    LWSTOOLCHAIN := -DLWS_WITHOUT_EXTENSIONS=1 -DLWS_WITH_SSL=0 -DCMAKE_TOOLCHAIN_FILE=$(CANOPY_EMBEDDED_ROOT)/3rdparty/libwebsockets/canopy-cross-compile.cmake
endif

# Removes built files for current build
.PHONY: clean
clean:
	rm -rf $(BUILD_OUTDIR)

# Removes built files for all build
.PHONY: sweep
sweep:
	rm -rf _out


.PHONY: libwebsockets-canopy
libwebsockets-canopy:
	mkdir -p $(BUILD_OUTDIR)/include
	mkdir -p $(BUILD_OUTDIR)/lib
	mkdir -p $(BUILD_OUTDIR)/intermediate/libwebsockets
	cd $(BUILD_OUTDIR)/intermediate/libwebsockets && cmake -DLWS_IPV6=0 $(LWSTOOLCHAIN) $(CANOPY_EMBEDDED_ROOT)/3rdparty/libwebsockets
	make -C $(BUILD_OUTDIR)/intermediate/libwebsockets
	mv $(BUILD_OUTDIR)/intermediate/libwebsockets/lib/libwebsockets-canopy.* $(BUILD_OUTDIR)/lib/
	cp ../3rdparty/libwebsockets/lib/libwebsockets.h $(BUILD_OUTDIR)/include

.PHONY: libred-canopy
libred-canopy:
	mkdir -p $(BUILD_OUTDIR)/lib
	make -C $(CANOPY_EMBEDDED_ROOT)/3rdparty/libred
	mv $(CANOPY_EMBEDDED_ROOT)/3rdparty/libred/libred.so $(BUILD_OUTDIR)/lib/libred-canopy.so
	cp $(CANOPY_EMBEDDED_ROOT)/3rdparty/libred/include/* $(BUILD_OUTDIR)/include
	cp $(CANOPY_EMBEDDED_ROOT)/3rdparty/libred/under_construction/*.h $(BUILD_OUTDIR)/include

.PHONY: libsddl
libsddl:
	mkdir -p $(BUILD_OUTDIR)/lib
	make -C ../libsddl
	mv ../libsddl/libsddl.so $(BUILD_OUTDIR)/lib/libsddl.so
	cp ../libsddl/include/*.h $(BUILD_OUTDIR)/include


.PHONY: libcanopy
libcanopy:
	mkdir -p $(BUILD_OUTDIR)/lib
	make -C ../libcanopy
	mv ../libcanopy/$(CANOPY_EDK_BUILD_OUTDIR)/libcanopy.so $(BUILD_OUTDIR)/lib/libcanopy.so
	cp ../libcanopy/include/*.h $(BUILD_OUTDIR)/include

.PHONY: install
install:
	mkdir -p /usr/local/lib
	mkdir -p /usr/local/include
	cp $(BUILD_OUTDIR)/lib/* /usr/local/lib
	cp $(BUILD_OUTDIR)/include/* /usr/local/include
