TERMUX_PKG_HOMEPAGE=https://github.com/chunga2020/pomodoro_curses
TERMUX_PKG_DESCRIPTION="A simple pomodoro timer written with the Ncurses library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5
TERMUX_PKG_SRCURL=https://github.com/chunga2020/pomodoro_curses/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9a0de71d1b4ba2cb3ff404e52c4eedf63afde0cc11c378663c3edd9464cd1ff8
TERMUX_PKG_DEPENDS="libinih, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/pomodoro_curses
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 doc/pomodoro_curses.1
	install -Dm600 -t $TERMUX_PREFIX/share/pomodoro-curses config-sample.ini
}
