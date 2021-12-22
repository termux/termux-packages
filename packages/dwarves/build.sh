TERMUX_PKG_HOMEPAGE=https://git.kernel.org/cgit/devel/pahole/pahole.git/
TERMUX_PKG_DESCRIPTION="Pahole and other DWARF utils"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22
TERMUX_PKG_SRCURL=http://fedorapeople.org/~acme/dwarves/dwarves-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8bcba48be39da2868142440dc2ee7f1d7b99ffec8095e3a1afb280dc1a7c63df
TERMUX_PKG_DEPENDS="argp, libdw, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-D__LIB=lib"

termux_step_pre_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h "$TERMUX_PKG_SRCDIR"/
}
