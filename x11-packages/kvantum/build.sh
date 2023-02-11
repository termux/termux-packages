TERMUX_PKG_HOMEPAGE=https://github.com/tsujan/Kvantum
TERMUX_PKG_DESCRIPTION="SVG-based theme engine for Qt5"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=1.0.9
TERMUX_PKG_SRCURL="https://github.com/tsujan/Kvantum/releases/download/V${TERMUX_PKG_VERSION}/Kvantum-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=30fc309cb15d96dc66c93c6fd3a1e64d6373c65ed8a9e413987cf13444906407
TERMUX_PKG_DEPENDS="kwindowsystem, libc++, libx11, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/Kvantum"
}
