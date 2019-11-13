TERMUX_PKG_HOMEPAGE=http://tintin.sourceforge.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.01.92
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/tintin/files/tintin-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3386d49810f2dbc162f890f26bb81e3807af34753d7a4ead64cc40e845cba845
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=no"
TERMUX_PKG_DEPENDS="pcre, libgnutls, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_extract_package() {
	TERMUX_PKG_SRCDIR+="/src"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}
