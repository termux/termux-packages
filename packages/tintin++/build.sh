TERMUX_PKG_HOMEPAGE=https://tintin.mudhalla.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.02.20
TERMUX_PKG_SRCURL=https://github.com/scandum/tintin/releases/download/$TERMUX_PKG_VERSION/tintin-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=331673e6ee3c945cf27e1c0d71cec1225c9d992588ed73b2a707c4c49523e8d2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=no"
TERMUX_PKG_DEPENDS="pcre, libgnutls, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/src"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}
