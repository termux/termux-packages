TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.05.22"
TERMUX_PKG_SRCURL="https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6edeb89e48caa31fd856598a638ef7e8db507c54ec3a01f002badc77223eb769
TERMUX_PKG_DEPENDS="freetype, harfbuzz, libc++, lua54, lunasvg"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn, stb"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DSTB_INCLUDE_DIR=$TERMUX__PREFIX__INCLUDE_DIR/stb"

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
}
