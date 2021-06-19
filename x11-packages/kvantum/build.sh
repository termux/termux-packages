TERMUX_PKG_HOMEPAGE=https://github.com/tsujan/Kvantum
TERMUX_PKG_DESCRIPTION="SVG-based theme engine for Qt5"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=0.19.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/tsujan/Kvantum/releases/download/V${TERMUX_PKG_VERSION}/Kvantum-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c3c73ee62c23c60342b6a2aaca670e2a6316bc17b51d8666278399c36085ee7b
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtx11extras, qt5-qtsvg, kwindowsystem"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/Kvantum"
}
