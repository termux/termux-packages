TERMUX_PKG_HOMEPAGE=http://www.clifford.at/stfl
TERMUX_PKG_DESCRIPTION="Structured Terminal Forms Language/Library"
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_SRCURL=http://www.clifford.at/stfl/stfl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=stfl-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	# stfl doesn't contain configure script
	return
}

termux_step_make () {
	export CFLAGS="-I. -fPIC -Wall -Os -ggdb"
	export LDFLAGS="-L${TERMUX_PREFIX}/lib -lncursesw -liconv"
	make
}
