TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.09.26"
TERMUX_PKG_SRCURL=https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5a0eb1485ad939baddfbdc9046c41d60756a9ced123cd28d32525476da8ae08b
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
}
