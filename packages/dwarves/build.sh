TERMUX_PKG_HOMEPAGE=https://git.kernel.org/cgit/devel/pahole/pahole.git/
TERMUX_PKG_DESCRIPTION="Pahole and other DWARF utils"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.32"
TERMUX_PKG_SRCURL=https://fedorapeople.org/~acme/dwarves/dwarves-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=319cbf319e9fc92065a5407ce47eb868d73566f3d4840a56832734e4579df947
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="argp, libandroid-spawn, libdw, libelf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-D__LIB=lib"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn"
	cp "$TERMUX_PKG_BUILDER_DIR"/obstack.h "$TERMUX_PKG_SRCDIR"/
}
