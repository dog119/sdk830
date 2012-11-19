
ifneq ($(FS_TYPE),)

target-finalize: fs-overlays

fs-overlays:
	@$(call MESSAGE,"Overlays for $(FS_TYPE)");
	prjfilter $(PRJROOT)/src/$(FS_TYPE)/overlay $(TARGET_DIR) -c $(BUILDROOT)/.prjconfig
ifeq ($(FS_TYPE),rootfs)
#rootfs specific overlays
	cp -f $(BUILDROOT)/comps/fwinfo/firmwareDesc $(TARGET_DIR)
	-cp -fr /opt/philips/sp7.2/stb810-SP7.2/build_256M_NOIP/rootfs/usr/share/zoneinfo $(TARGET_DIR)/usr/share
	cp $(PRJROOT)/src/$(FS_TYPE)/dev/dev-stapi-$(STAPISDK_VERSION).tar $(TARGET_DIR)/etc/dev-stapi.tar
endif
ifeq ($(FS_TYPE),initramfs)
#initramfs specific overlays
#Add open keys. clientUpdater work from initramfs, so copy keys there.
	rm -rf $(TARGET_DIR)/config.firmware/keys
	mkdir -p $(TARGET_DIR)/config.firmware/keys
	for i in elecard $(BUILD_ADD_KEYS_TO_FW); do \
		cp -f $(PRJROOT)/src/firmware/keys/open/$$i.pem $(TARGET_DIR)/config.firmware/keys/; \
	done
endif
	@echo

endif #ifneq ($(FS_TYPE),)