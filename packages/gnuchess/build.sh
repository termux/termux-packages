TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/chess/
TERMUX_PKG_DESCRIPTION="Chess-playing program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.3.0"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/chess/gnuchess-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b37bec2098c2ad695b7443e5d7944dc6dc8284f8d01fcc30bdb94dd033ca23a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_RM_AFTER_INSTALL="bin/gnuchessu bin/gnuchessx"
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	CXXFLAGS+=" -Wno-error=register"
}
