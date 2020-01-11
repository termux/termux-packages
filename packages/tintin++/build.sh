TERMUX_PKG_HOMEPAGE=http://tintin.sourceforge.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.02.00
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/tintin/files/tintin-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b1bc35f3137db378ba7f26c9f169ed8bcca4617ca4ec3356f14d0b083f5c150b
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
