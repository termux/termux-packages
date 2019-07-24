TERMUX_PKG_HOMEPAGE=http://www.vanheusden.com/multitail/
TERMUX_PKG_DESCRIPTION="Tool to monitor logfiles and command output in multiple windows in a terminal, colorize, filter and merge"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=6.4.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://fossies.org/linux/privat/multitail-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=af1d5458a78ad3b747c5eeb135b19bdca281ce414cefdc6ea0cff6d913caa1fd
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	CFLAGS+=" -DNCURSES_WIDECHAR"
	LDFLAGS+=" -landroid-glob"
}
