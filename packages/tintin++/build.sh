TERMUX_PKG_HOMEPAGE=https://tintin.mudhalla.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.02.02
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/tintin/files/tintin-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c5d8b6c930ec0beb9f45de434e079dddb17b48f8a3acff08acbc9d1bd15dd487
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
