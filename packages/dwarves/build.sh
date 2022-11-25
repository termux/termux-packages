TERMUX_PKG_HOMEPAGE=https://git.kernel.org/cgit/devel/pahole/pahole.git/
TERMUX_PKG_DESCRIPTION="Pahole and other DWARF utils"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://fedorapeople.org/~acme/dwarves/dwarves-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=576bc112b95937dfbcd347c423696ee9e1992a338fdca1acacca736fd95f69c2
TERMUX_PKG_DEPENDS="argp, libdw, libelf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-D__LIB=lib"

termux_step_pre_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h "$TERMUX_PKG_SRCDIR"/
}
