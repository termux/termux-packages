TERMUX_PKG_HOMEPAGE=https://git.kernel.org/cgit/devel/pahole/pahole.git/
TERMUX_PKG_DESCRIPTION="Pahole and other DWARF utils"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.31"
TERMUX_PKG_SRCURL=https://fedorapeople.org/~acme/dwarves/dwarves-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0a7f255ccacf8cc7f8cd119099eb327179b4b3c67cb015af646af6d0cb03054d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="argp, libdw, libelf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-D__LIB=lib"

termux_step_pre_configure() {
	cp "$TERMUX_PKG_BUILDER_DIR"/obstack.h "$TERMUX_PKG_SRCDIR"/
}
