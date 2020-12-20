TERMUX_PKG_HOMEPAGE=http://lazyread.sourceforge.net/
TERMUX_PKG_DESCRIPTION="An auto-scroller, pager, and e-book reader all in one"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_SRCURL=https://liquidtelecom.dl.sourceforge.net/project/lazyread/lazyread/lazyread%20${TERMUX_PKG_VERSION}/lazyread-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7e462c5c9fe104d69e410c537336af838a30a030699dd9320f75fe85a20746a1
TERMUX_PKG_DEPENDS="coreutils, lesspipe, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	$CC $CPPFLAGS $CFLAGS lazyread.c -o lazyread $LDFLAGS -lncurses
}

termux_step_make_install() {
	install -Dm700 lazyread $TERMUX_PREFIX/bin/lazyread
}
