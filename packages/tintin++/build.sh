TERMUX_PKG_HOMEPAGE=https://tintin.mudhalla.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.02.30
TERMUX_PKG_SRCURL=https://github.com/scandum/tintin/releases/download/$TERMUX_PKG_VERSION/tintin-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ce25add4554534e92f9809c575ccf17d4006c8916f5ff2bce2c400d928c16cd4
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=no"
TERMUX_PKG_DEPENDS="pcre, libgnutls, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/src"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}
