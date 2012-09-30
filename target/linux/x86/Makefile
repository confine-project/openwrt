#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=i386
BOARD:=x86
BOARDNAME:=x86
FEATURES:=squashfs jffs2 ext4 vdi vmdk pcmcia targz
SUBTARGETS=generic olpc xen_domu ep80579 net5501 kvm_guest geos alix2 thincan lxc_host lxc_host_alix2

#LINUX_VERSION:=3.3
#(Latest openwrt Trunk but without LINUX_VERSION=3.3 lxc patches from xavileon)
LINUX_VERSION:=3.3.8

include $(INCLUDE_DIR)/target.mk

$(eval $(call BuildTarget))

$(eval $(call $(if $(CONFIG_TARGET_ROOTFS_ISO),RequireCommand,Ignore),mkisofs, \
   	Please install mkisofs. \
))
