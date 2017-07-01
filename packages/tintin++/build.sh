TERMUX_PKG_HOMEPAGE=http://tintin.sourceforge.net
TERMUX_PKG_DESCRIPTION="Classic text-based MUD client"
TERMUX_PKG_VERSION=2.01.2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/${TERMUX_PKG_VERSION}/tintin-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=tt/src
TERMUX_PKG_SHA256=01e11e3cded48ff686b2ea16e767acf1f6b5ea326551ecff091552e89f4a038e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=no"
TERMUX_PKG_DEPENDS="pcre, libgnutls, libutil"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}
