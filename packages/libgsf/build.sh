TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libgsf
TERMUX_PKG_DESCRIPTION="The G Structured File Library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.52"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libgsf/${TERMUX_PKG_VERSION%.*}/libgsf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9181c914b9fac0e05d6bcaa34c7b552fe5fc0961d3c9f8c01ccc381fb084bcf0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libbz2, libxml2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection
--with-bz2
--without-gdk-pixbuf
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir
	CFLAGS+=" -I${TERMUX_PREFIX}/include/libxml2 -includelibxml/xmlerror.h"
}

termux_step_post_configure() {
	touch ./gsf/g-ir-scanner
}
