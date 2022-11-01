TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Panel for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-panel/${_MAJOR_VERSION}/xfce4-panel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ee7c190d62c919afb91f91c798a5f804c5d2ff8833bb6fe352f24d129c801ba9
TERMUX_PKG_DEPENDS="atk, exo, fontconfig, freetype, garcon, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-shmem, libcairo, libice, libpixman, libpng, libsm, libwnck, libx11, libxcb, libxext, libxfce4ui, libxfce4util, libxrender, pango, startup-notification, xfconf, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, hicolor-icon-theme"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk-doc-html=no
--enable-introspection=yes
--enable-vala=no
--disable-dbusmenu-gtk3
"

termux_step_pre_configure() {
	termux_setup_gir
}
