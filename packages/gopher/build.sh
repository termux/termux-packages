TERMUX_PKG_HOMEPAGE=gopher://gopher.quux.org/1/devel/gopher
TERMUX_PKG_DESCRIPTION="University of Minnesota gopher"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.19
TERMUX_PKG_SRCURL=https://snapshot.debian.org/archive/debian/20250602T202823Z/pool/main/g/gopher/gopher_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e394e1d4352810f1aef79e6dc6067b00e837c7ca0cb4545d7ce9abef9e0e8485
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -lncursesw"
}
