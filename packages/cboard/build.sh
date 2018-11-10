TERMUX_PKG_HOMEPAGE=https://benkibbey.wordpress.com/cboard/
TERMUX_PKG_DESCRIPTION="PGN browser, editor and chess engine frontend"
TERMUX_PKG_VERSION=0.7.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/c-board/${TERMUX_PKG_VERSION}/cboard-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8caeabc5cccd35c0f093d36ec0088667530d92e178d328ef345c4c20052d25e2
TERMUX_PKG_DEPENDS="libandroid-support,libandroid-glob,gnuchess, ncurses, ncurses-ui-libs"

termux_step_pre_configure () {
	CFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
	LDFLAGS+=" -landroid-glob"
	if [ "$TERMUX_DEBUG" == "true" ]; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.termux-build/cboard/src/libchess/pgn.c:2235:33: error: 'umask' called with invalid mode
		# mode = umask(600);
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
