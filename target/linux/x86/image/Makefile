# 
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

export PATH=$(TARGET_PATH):/sbin

GRUB2_MODULES = biosdisk boot chain configfile ext2 linux ls part_msdos reboot serial vga
GRUB_TERMINALS =
GRUB_SERIAL_CONFIG =
GRUB_TERMINAL_CONFIG =
GRUB_CONSOLE_CMDLINE =

ifneq ($(CONFIG_X86_GRUB_CONSOLE),)
  GRUB_CONSOLE_CMDLINE += console=tty0
  GRUB_TERMINALS += console
endif

USE_ATKBD = generic kvm_guest

ifneq ($(strip $(foreach subtarget,$(USE_ATKBD),$(CONFIG_TARGET_x86_$(subtarget)))),)
  GRUB2_MODULES +=
endif

ifneq ($(CONFIG_X86_GRUB_SERIAL),)
  GRUB_CONSOLE_CMDLINE += console=$(call qstrip,$(CONFIG_X86_GRUB_SERIAL)),$(CONFIG_X86_GRUB_BAUDRATE)n8
  GRUB_SERIAL_CONFIG := serial --unit=0 --speed=$(CONFIG_X86_GRUB_BAUDRATE) --word=8 --parity=no --stop=1
  GRUB_TERMINALS += serial
endif

ifneq ($(GRUB_TERMINALS),)
  ifneq ($(CONFIG_X86_USE_GRUB2),)
    GRUB_TERMINAL_CONFIG := terminal_input $(GRUB_TERMINALS); terminal_output $(GRUB_TERMINALS)
  else
    GRUB_TERMINAL_CONFIG := terminal --timeout=2 $(GRUB_TERMINALS)
  endif
endif

ROOTPART:=$(call qstrip,$(CONFIG_TARGET_ROOTFS_PARTNAME))

GRUB_TIMEOUT:=$(call qstrip,$(CONFIG_X86_GRUB_TIMEOUT))

ifneq ($(CONFIG_X86_GRUB_IMAGES),)

  BOOTOPTS:=$(call qstrip,$(CONFIG_X86_GRUB_BOOTOPTS))

  define Image/cmdline/ext4
    root=$(ROOTPART) rootfstype=ext4 rootwait
  endef
  
  define Image/cmdline/jffs2-64k
    block2mtd.block2mtd=$(ROOTPART),65536,rootfs root=/dev/mtdblock0 rootfstype=jffs2 rootwait
  endef

  define Image/cmdline/jffs2-128k
    block2mtd.block2mtd=$(ROOTPART),131072,rootfs root=/dev/mtdblock0 rootfstype=jffs2 rootwait
  endef

  define Image/cmdline/squashfs
    block2mtd.block2mtd=$(ROOTPART),65536,rootfs root=/dev/mtdblock0 rootfstype=squashfs rootwait
  endef

  define Image/Build/grub
	# left here because the image builder doesnt need these
	$(INSTALL_DIR) $(KDIR)/root.grub/boot/grub
	$(CP) \
		$(KDIR)/stage1 \
		$(KDIR)/stage2 \
		$(KDIR)/e2fs_stage1_5 \
		$(KDIR)/root.grub/boot/grub/
	$(CP) $(KDIR)/bzImage $(KDIR)/root.grub/boot/vmlinuz
	sed \
		-e 's#@SERIAL_CONFIG@#$(strip $(GRUB_SERIAL_CONFIG))#g' \
		-e 's#@TERMINAL_CONFIG@#$(strip $(GRUB_TERMINAL_CONFIG))#g' \
		-e 's#@CMDLINE@#$(strip $(call Image/cmdline/$(1)) $(BOOTOPTS) $(GRUB_CONSOLE_CMDLINE))#g' \
		-e 's#@TIMEOUT@#$(GRUB_TIMEOUT)#g' \
		./menu.lst > $(KDIR)/root.grub/boot/grub/menu.lst
	PADDING="$(CONFIG_TARGET_IMAGES_PAD)" PATH="$(TARGET_PATH)" ./gen_image_grub.sh \
		$(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).img \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(KDIR)/root.grub \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(KDIR)/root.$(1)
	$(call Image/Build/grub/$(1))
  endef

  define Image/Prepare/grub
	# for the image builder
	$(CP) \
		$(STAGING_DIR)/usr/lib/grub/i386-openwrt/stage1 \
		$(STAGING_DIR)/usr/lib/grub/i386-openwrt/stage2 \
		$(STAGING_DIR)/usr/lib/grub/i386-openwrt/stage2_eltorito \
		$(STAGING_DIR)/usr/lib/grub/i386-openwrt/e2fs_stage1_5 \
		$(KDIR)/
  endef

  define Image/Build/grub2
	# left here because the image builder doesnt need these
	$(INSTALL_DIR) $(KDIR)/root.grub/boot/grub $(KDIR)/grub2
	$(CP) $(KDIR)/bzImage $(KDIR)/root.grub/boot/vmlinuz
	grub-mkimage \
		-o $(KDIR)/grub2/core.img \
		-O i386-pc \
		-c ./grub-early.cfg \
		$(GRUB2_MODULES)
	$(CP) $(STAGING_DIR_HOST)/lib/grub/i386-pc/*.img $(KDIR)/grub2/
	echo '(hd0) $(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).img' > $(KDIR)/grub2/device.map
	sed \
		-e 's#@SERIAL_CONFIG@#$(strip $(GRUB_SERIAL_CONFIG))#g' \
		-e 's#@TERMINAL_CONFIG@#$(strip $(GRUB_TERMINAL_CONFIG))#g' \
		-e 's#@CMDLINE@#$(strip $(call Image/cmdline/$(1)) $(BOOTOPTS) $(GRUB_CONSOLE_CMDLINE))#g' \
		-e 's#@TIMEOUT@#$(GRUB_TIMEOUT)#g' \
		./grub.cfg > $(KDIR)/root.grub/boot/grub/grub.cfg
	PADDING="$(CONFIG_TARGET_IMAGES_PAD)" PATH="$(TARGET_PATH)" ./gen_image_generic.sh \
		$(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).img \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(KDIR)/root.grub \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(KDIR)/root.$(1) \
		256
	grub-bios-setup \
		--device-map="$(KDIR)/grub2/device.map" \
		-d "$(KDIR)/grub2" \
		-r "hd0,msdos1" \
		"$(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).img"
	$(call Image/Build/grub/$(1))
  endef
endif

ROOTDELAY=10

ifneq ($(CONFIG_OLPC_BOOTSCRIPT_IMAGES),)

  define Image/cmdline/ext4
    root=$(ROOTPART) rootfstype=ext4 rootwait
  endef

  define Image/cmdline/jffs2-64k
    block2mtd.block2mtd=$(ROOTPART),65536,rootfs root=/dev/mtdblock0 rootfstype=jffs2 rootdelay=$(ROOTDELAY)
  endef

  define Image/cmdline/jffs2-128k
    block2mtd.block2mtd=$(ROOTPART),131072,rootfs root=/dev/mtdblock0 rootfstype=jffs2 rootdelay=$(ROOTDELAY)
  endef

  define Image/cmdline/squashfs
    block2mtd.block2mtd=$(ROOTPART),65536,rootfs root=/dev/mtdblock0 rootfstype=squashfs rootdelay=$(ROOTDELAY)
  endef

  define Image/Build/bootscript
	# left here because the image builder doesnt need these
	$(INSTALL_DIR) $(KDIR)/root.bootscript/boot
	$(CP) $(KDIR)/bzImage $(KDIR)/root.bootscript/boot/vmlinuz
	sed -e 's#@CMDLINE@#$(strip $(call Image/cmdline/$(1))) $(BOOTOPTS)#g' \
		./olpc.fth > $(KDIR)/root.bootscript/boot/olpc.fth
	PADDING="$(CONFIG_TARGET_IMAGES_PAD)" PATH="$(TARGET_PATH)" ./gen_image_olpc.sh \
		$(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).img \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $(KDIR)/root.bootscript \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(KDIR)/root.$(1)
  endef

endif

define Image/Build/squashfs
	$(call prepare_generic_squashfs,$(KDIR)/root.squashfs)
endef

define Image/Build/iso 
	$(INSTALL_DIR) $(KDIR)/root.grub/boot/grub
	$(CP) \
		$(KDIR)/stage2_eltorito \
		$(KDIR)/root.grub/boot/grub/ 
	sed \
		-e 's#@SERIAL_CONFIG@#$(strip $(GRUB_SERIAL_CONFIG))#g' \
		-e 's#@TERMINAL_CONFIG@#$(strip $(GRUB_TERMINAL_CONFIG))#g' \
		-e 's#@CMDLINE@#$(strip $(call Image/cmdline/$(1)) $(BOOTOPTS) $(GRUB_CONSOLE_CMDLINE))#g' \
		-e 's#(hd0,0)#(cd)#g' \
		./menu.lst > $(KDIR)/root.grub/boot/grub/menu.lst
	$(CP) $(KDIR)/bzImage $(KDIR)/root.grub/boot/vmlinuz 
	mkisofs -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table \
		-o $(KDIR)/root.iso $(KDIR)/root.grub 
endef 

ifneq ($(CONFIG_X86_VDI_IMAGES),)
  define Image/Build/vdi
    # left here because the image builder doesnt need these
    ifeq ($(1),ext4)
		rm $(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).vdi || true
		qemu-img convert -f raw -O vdi \
			$(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).img \
			$(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).vdi
		# XXX: VBoxManage insists on setting perms to 0600
		chmod 0644 $(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).vdi
    endif
  endef
endif

ifneq ($(CONFIG_X86_VMDK_IMAGES),)
  define Image/Build/vmdk
    # left here because the image builder doesnt need these
    ifeq ($(1),ext4)
		rm $(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).vmdk || true
		qemu-img convert -f raw -O vmdk \
			$(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).img \
			$(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).vmdk
    endif
  endef
endif

define Image/Build/gzip
	gzip -f9 $(BIN_DIR)/$(IMG_PREFIX)-combined-$(1).img
	gzip -f9 $(BIN_DIR)/$(IMG_PREFIX)-rootfs-$(1).img
endef

ifneq ($(CONFIG_TARGET_IMAGES_GZIP),)
  define Image/Build/gzip/ext4
	$(call Image/Build/gzip,ext4)
  endef
  ifneq ($(CONFIG_TARGET_IMAGES_PAD),)
    define Image/Build/gzip/squashfs
	$(call Image/Build/gzip,squashfs)
    endef
    define Image/Build/gzip/jffs2-64k
	$(call Image/Build/gzip,jffs2-64k)
    endef
    define Image/Build/gzip/jffs2-128k
	$(call Image/Build/gzip,jffs2-128k)
    endef
  endif
endif

define Image/BuildKernel
	$(CP) $(KDIR)/bzImage $(BIN_DIR)/$(IMG_PREFIX)-vmlinuz
  ifneq ($(CONFIG_X86_ETHERBOOT_IMAGES),)
	rm -f $(BIN_DIR)/$(IMG_PREFIX)-etherboot
	$(STAGING_DIR_HOST)/bin/mkelfImage \
		--append=$(CONFIG_X86_ETHERBOOT_BOOTOPTS) \
		$(KDIR)/bzImage \
		$(BIN_DIR)/$(IMG_PREFIX)-etherboot
  endif
endef

define Image/Prepare
	$(CP) $(LINUX_DIR)/arch/x86/boot/bzImage $(KDIR)/bzImage
	$(call Image/Prepare/bootscript)
	$(call Image/Prepare/$(if $(CONFIG_X86_USE_GRUB2),grub2,grub))
endef

define Image/Build
	$(call Image/Build/$(1))
	$(call Image/Build/bootscript,$(1))
  ifneq ($(1),iso)
	$(call Image/Build/$(if $(CONFIG_X86_USE_GRUB2),grub2,grub),$(1))
	$(call Image/Build/vdi,$(1))
	$(call Image/Build/vmdk,$(1))
  endif
	$(CP) $(KDIR)/root.$(1) $(BIN_DIR)/$(IMG_PREFIX)-rootfs-$(1).img
	$(CP) $(KDIR)/bzImage $(BIN_DIR)/$(IMG_PREFIX)-vmlinuz
	$(call Image/Build/gzip/$(1))
endef

$(eval $(call BuildImage))
