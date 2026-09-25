TERMUX_PKG_HOMEPAGE=https://github.com/martijnvanbrummelen/nwipe
TERMUX_PKG_DESCRIPTION="A program that will securely erase the entire contents of disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.42"
TERMUX_PKG_SRCURL=https://github.com/martijnvanbrummelen/nwipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0e38474495cc6c86043a1de0460cf0dc009ad68e079ee23d71569e80e55cd2e6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, parted, libconfig, hdparm"
TERMUX_PKG_SUGGESTS="smartmontools"

termux_step_pre_configure() {
	autoreconf -fi
}
