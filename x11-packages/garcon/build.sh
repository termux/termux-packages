TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Implementation of the freedesktop.org menu specification"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.18
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/garcon/${_MAJOR_VERSION}/garcon-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=fe7a932a6dac95eb1438f3fbfd53096756ff2e1cb179d10d0fb796cefbb4c20b
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxfce4ui, libxfce4util, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_CONFLICTS="libgarcon"
TERMUX_PKG_REPLACES="libgarcon"
TERMUX_PKG_PROVIDES="libgarcon"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
