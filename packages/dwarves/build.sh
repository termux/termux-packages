TERMUX_PKG_HOMEPAGE=https://git.kernel.org/cgit/devel/pahole/pahole.git/
TERMUX_PKG_DESCRIPTION="Pahole and other DWARF utils"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.23
TERMUX_PKG_SRCURL=http://fedorapeople.org/~acme/dwarves/dwarves-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f085c25f068627d10e54bd030464f8952f5b2211d4ba26047fe209377470862a
TERMUX_PKG_DEPENDS="argp, libdw, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-D__LIB=lib"

termux_step_pre_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h "$TERMUX_PKG_SRCDIR"/
}
