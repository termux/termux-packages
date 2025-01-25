TERMUX_PKG_HOMEPAGE=https://git.kernel.org/cgit/devel/pahole/pahole.git/
TERMUX_PKG_DESCRIPTION="Pahole and other DWARF utils"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29"
TERMUX_PKG_SRCURL=https://fedorapeople.org/~acme/dwarves/dwarves-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9b30edbeb5fb973ad615d3a80cd0e73c7b816e7adb740bfad81ad759ed1b2a19
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="argp, libdw, libelf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-D__LIB=lib"

termux_step_pre_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/obstack.h "$TERMUX_PKG_SRCDIR"/
}
