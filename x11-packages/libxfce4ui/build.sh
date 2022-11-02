TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/libxfce4ui/${_MAJOR_VERSION}/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a96dabc333a89f4bc2faa4a02fd40c8e8070fd17d65e03c0ec77c7d2cc1284b0
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libsm, libx11, libxfce4util, pango, startup-notification, xfconf"
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
