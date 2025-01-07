TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-genmon-plugin
TERMUX_PKG_DESCRIPTION="Display cyclically run script or program output onto the panel"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.1"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-genmon-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-genmon-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=de540562e1ea58f35a9c815e20736d26af541a0a9372011148cb75b5f0b65951
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"
