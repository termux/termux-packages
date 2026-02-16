TERMUX_PKG_HOMEPAGE=https://github.com/directvt/vtm
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with TUI window manager and multi-party session sharing"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.02.16"
TERMUX_PKG_SRCURL=https://github.com/directvt/vtm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=909b1d63dfc539a5c0e8bcf6980d559d657df931b350063b09ffadae3b510c37
TERMUX_PKG_DEPENDS="freetype, harfbuzz, libc++, lua54"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CXXFLAGS+=" -pthread"
}
