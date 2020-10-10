TERMUX_PKG_HOMEPAGE=https://tintin.mudhalla.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.02.04
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/scandum/tintin/releases/download/$TERMUX_PKG_VERSION/tintin-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=479216011134568b43dbe872a3c2c7dc2a2fb0874bf6655f2a6f468637103ef0
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
