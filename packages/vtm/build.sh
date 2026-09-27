TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.09.27"
TERMUX_PKG_SRCURL="https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=dbe477bb0d69b8674d47dfc4f82e44a1caff1ffca12e1ea8622b445267f0bdc8
TERMUX_PKG_DEPENDS="freetype, harfbuzz, libc++, lua54, lunasvg"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn, stb"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
	export STB_INCLUDE_DIR="$TERMUX__PREFIX__INCLUDE_DIR/stb"
}
