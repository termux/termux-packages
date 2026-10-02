TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.10.01"
TERMUX_PKG_SRCURL="https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fbd08469bf86a9417ec584f78745b17eae1cd5a7a548879ec6ae75bc410f1523
TERMUX_PKG_DEPENDS="freetype, harfbuzz, libc++, lua54, lunasvg"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn, stb"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
	export STB_INCLUDE_DIR="$TERMUX__PREFIX__INCLUDE_DIR/stb"
}
