TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.07.24"
TERMUX_PKG_SRCURL=https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6c6306d2611215d36910e58cace3f3ff6356c76ac1cba82112d6c31eaa92f952
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
}
