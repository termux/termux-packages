TERMUX_PKG_HOMEPAGE=http://www.clifford.at/stfl
TERMUX_PKG_DESCRIPTION="Structured Terminal Forms Language/Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://www.clifford.at/stfl/stfl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	CC+=" $CPPFLAGS"
	CFLAGS+=" -fPIC -I. -D_XOPEN_SOURCE_EXTENDED=1"
	LDFLAGS+=" -lncursesw -liconv"
}
