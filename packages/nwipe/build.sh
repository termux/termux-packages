TERMUX_PKG_HOMEPAGE=https://github.com/martijnvanbrummelen/nwipe
TERMUX_PKG_DESCRIPTION="A program that will securely erase the entire contents of disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.34
TERMUX_PKG_SRCURL=https://github.com/martijnvanbrummelen/nwipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=be3122fcd8a6c8099ee1ae37dd640848774fdb84a7045a7b33dcf54c1ec69c29
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, parted"

termux_step_pre_configure() {
	autoreconf -fi
}
