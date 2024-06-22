TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Panel for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.18.6"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-panel/${TERMUX_PKG_VERSION%.*}/xfce4-panel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=21337161f58bb9b6e42760cb6883bc79beea27882aa6272b61f0e09d750d7c62
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, exo, garcon, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libsm, libwnck, libx11, libxext, libxfce4ui, libxfce4util, pango, xfconf, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, hicolor-icon-theme"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk-doc-html=no
--enable-introspection=yes
--enable-vala=no
--disable-dbusmenu-gtk3
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir
}
