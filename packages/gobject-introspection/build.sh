TERMUX_PKG_HOMEPAGE=https://gi.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Uniform machine readable API"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.68.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/GNOME/gobject-introspection/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=13595a257df7d0b71b002ec115f1faafd3295c9516f307e2c57bd219d5cd8369
TERMUX_PKG_BUILD_DEPENDS="glib, python"

termux_step_pre_configure() {
	CPPFLAGS+=" -I$TERMUX_PREFIX/include/python3.10 -I$TERMUX_PREFIX/include/python3.10/cpython"
}
