TERMUX_PKG_HOMEPAGE=http://tintin.sourceforge.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.01.91
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/tintin/files/tintin-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3596a6d540d58162dc60c318c520cb94ee52fb438b5db8a2fa2513c47fbe6359
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
