TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.01.11"
TERMUX_PKG_SRCURL=https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d5a0339831702df3d720429516202e3a2cfdbd2410de493d2cc6eb94af80bd20
TERMUX_PKG_DEPENDS="freetype, harfbuzz, libc++, liblua54"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
}
