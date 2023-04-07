TERMUX_PKG_HOMEPAGE=https://github.com/LonnyGomes/hexcurse
TERMUX_PKG_DESCRIPTION="Console hexeditor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.60.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/LonnyGomes/hexcurse/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f6919e4a824ee354f003f0c42e4c4cef98a93aa7e3aa449caedd13f9a2db5530
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses"

termux_step_pre_configure() {
	export CFLAGS+=" -fcommon"
}
