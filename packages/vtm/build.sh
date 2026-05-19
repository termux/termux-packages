TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.05.18"
TERMUX_PKG_SRCURL="https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=21fb90a5370c2b58c3c4d9aac431e748ecf48dc18093de7f2f39af78483f3e61
TERMUX_PKG_DEPENDS="freetype, harfbuzz, libc++, lua54, lunasvg"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn, stb"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DSTB_INCLUDE_DIR=$TERMUX__PREFIX__INCLUDE_DIR/stb"

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
}
