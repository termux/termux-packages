TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.7
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/libxfce4ui/${_MAJOR_VERSION}/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d5d3e1c3750570cfed358734fddfa095ff60cd524cf0d2cef8d25b3b30dfacf3
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-shmem, libcairo, libice, libpixman, libpng, libsm, libx11, libxcb, libxext, libxfce4ui, libxfce4util, libxrender, pango, startup-notification, xfconf, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-vendor-info=Termux
--enable-introspection=yes
--enable-vala=no
--enable-gtk-doc-html=no
"

termux_step_pre_configure() {
	termux_setup_gir
}
