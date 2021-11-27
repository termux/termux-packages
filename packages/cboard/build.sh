TERMUX_PKG_HOMEPAGE=https://benkibbey.wordpress.com/cboard/
TERMUX_PKG_DESCRIPTION="PGN browser, editor and chess engine frontend"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.5
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/c-board/${TERMUX_PKG_VERSION}/cboard-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=dd748039f3531653e1573577cd814741524e1b16e16e3a841ef512e5150da6a0
TERMUX_PKG_DEPENDS="libandroid-support,libandroid-glob,gnuchess, ncurses, ncurses-ui-libs"

termux_step_pre_configure() {
	CFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX -fcommon"
	LDFLAGS+=" -landroid-glob"

	if $TERMUX_DEBUG_BUILD; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.termux-build/cboard/src/libchess/pgn.c:2235:33: error: 'umask' called with invalid mode
		# mode = umask(600);
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
