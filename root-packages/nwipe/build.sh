TERMUX_PKG_HOMEPAGE=https://github.com/martijnvanbrummelen/nwipe
TERMUX_PKG_DESCRIPTION="A program that will securely erase the entire contents of disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.39"
TERMUX_PKG_SRCURL=https://github.com/martijnvanbrummelen/nwipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1038386b0c745ce418a43bf09ecf3a4ff17072961f4a3be0e940dfa45b10e9e4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, parted, libconfig, hdparm"
TERMUX_PKG_SUGGESTS="smartmontools"

termux_step_pre_configure() {
	autoreconf -fi
}
