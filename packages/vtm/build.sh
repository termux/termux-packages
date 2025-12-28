TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.12.26"
TERMUX_PKG_SRCURL=https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a6bc72c9d69849c99c8d98944435182fc1a6ac6b8791dde62c8904f6d4debe9
TERMUX_PKG_DEPENDS="freetype, harfbuzz, libc++, liblua54"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
}
