TERMUX_PKG_HOMEPAGE=https://benkibbey.wordpress.com/cboard/
TERMUX_PKG_DESCRIPTION="PGN browser, editor and chess engine frontend"
TERMUX_PKG_VERSION=0.7.3
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/c-board/${TERMUX_PKG_VERSION}/cboard-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libandroid-support,libandroid-glob,gnuchess, ncurses, ncurses-ui-libs"

termux_step_pre_configure () {
	CFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX"
	LDFLAGS+=" -landroid-glob"
}
