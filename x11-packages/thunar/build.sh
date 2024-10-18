TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/thunar/start
TERMUX_PKG_DESCRIPTION="Modern file manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.18.11"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/thunar/${TERMUX_PKG_VERSION%.*}/thunar-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7d0bdae2076a568c137d403ab5600e06a7a4f7a02514d486da7b8414aa75d612
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, desktop-file-utils, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libexif, libice, libnotify, libsm, libx11, libxfce4ui, libxfce4util, pango, pcre2, shared-mime-info, xfce4-panel, xfconf, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="gvfs, hicolor-icon-theme, thunar-archive-plugin, tumbler"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk-doc-html=no
--enable-introspection=yes
"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_gir
}
