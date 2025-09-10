TERMUX_PKG_HOMEPAGE=http://www.vanheusden.com/multitail/
TERMUX_PKG_DESCRIPTION="Tool to monitor logfiles and command output in multiple windows in a terminal, colorize, filter and merge"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.1.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/folkertvanheusden/multitail/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0c92bf5f504b39591bf3e2e30a1902925c11556e14b89a07cfa7533f9bd171b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libandroid-glob, ncurses, ncurses-ui-libs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/multitail.conf"

termux_step_pre_configure() {
	CFLAGS+=" -DNCURSES_WIDECHAR"
	LDFLAGS+=" -landroid-glob"
}
