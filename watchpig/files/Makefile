#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=watchpig
PKG_VERSION=1.0.1

PKG_LICENSE:=AGPL-3.0
PKG_LICENSE_FILES:=LICENSE
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/watchpig
  SECTION:=net
  CATEGORY:=services
  TITLE:=The combination of luci-app-mac and watchcat.
  MAINTAINER:=Twinzo1
endef

define Package/gdut-drcom/description
  Watchpig is a combination of open source software luci-app-mac and watchcat.
endef

define Package/watchpig/install
	$(INSTALL_DIR)  $(1)/usr/bin
	$(INSTALL_BIN)  $(PKG_BUILD_DIR)/watchpig.sh $(1)/usr/bin
endef

$(eval $(call BuildPackage,watchpig))
