TERMUX_PKG_HOMEPAGE=https://github.com/martijnvanbrummelen/nwipe
TERMUX_PKG_DESCRIPTION="A program that will securely erase the entire contents of disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.38"
TERMUX_PKG_SRCURL=https://github.com/martijnvanbrummelen/nwipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0c1b19d1a721b995504fc01c21363555f207b25d6749650355a8cd7be09824dd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, parted, libconfig"

termux_step_pre_configure() {
	autoreconf -fi
}
