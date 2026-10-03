TERMUX_PKG_HOMEPAGE=https://github.com/martijnvanbrummelen/nwipe
TERMUX_PKG_DESCRIPTION="A program that will securely erase the entire contents of disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.43"
TERMUX_PKG_SRCURL=https://github.com/martijnvanbrummelen/nwipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b1e9d94e1879934db688bce9515111ef6b0599b2244fdca2625a2e87e2d8e221
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, parted, libconfig, hdparm"
TERMUX_PKG_SUGGESTS="smartmontools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-libnvme
"

termux_step_pre_configure() {
	autoreconf -fi
}
