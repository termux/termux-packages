TERMUX_PKG_HOMEPAGE=https://github.com/martijnvanbrummelen/nwipe
TERMUX_PKG_DESCRIPTION="A program that will securely erase the entire contents of disks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.36"
TERMUX_PKG_SRCURL=https://github.com/martijnvanbrummelen/nwipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4165a02fdfbf91a22bf862b35f057d7672052ef02509c97387068b5df6bb5c5b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, ncurses-ui-libs, parted, libconfig"

termux_step_pre_configure() {
	autoreconf -fi
}
