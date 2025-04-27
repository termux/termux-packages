TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/chess/
TERMUX_PKG_DESCRIPTION="Chess-playing program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.2.11"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/chess/gnuchess-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d81140eea5c69d14b0cfb63816d4b4c9e18fba51f5267de5b1539f468939e9bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gnuchessu bin/gnuchessx"
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-error=register"
}
