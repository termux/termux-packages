TERMUX_PKG_HOMEPAGE=http://tintin.sourceforge.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.01.90
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/${TERMUX_PKG_VERSION:0:4}/tintin-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6b3eef2a993250d7094c5fcd4aa6ea3e2356228b006c70062f5757577c86936c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=no"
TERMUX_PKG_DEPENDS="pcre, libgnutls, libutil, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_extract_package() {
	TERMUX_PKG_SRCDIR+="/src"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}
