TERMUX_PKG_HOMEPAGE=https://github.com/tsujan/Kvantum
TERMUX_PKG_DESCRIPTION="SVG-based theme engine for Qt5"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.10"
TERMUX_PKG_SRCURL="https://github.com/tsujan/Kvantum/releases/download/V${TERMUX_PKG_VERSION}/Kvantum-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4a070a1a6fac3d1861010aa44d34e665e4697bc64c4c5015a6448203c31f1f1f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="kwindowsystem, libc++, libx11, qt5-qtbase, qt5-qtsvg, qt5-qtx11extras"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/Kvantum"
}
