TERMUX_PKG_HOMEPAGE=https://github.com/tsujan/Kvantum
TERMUX_PKG_DESCRIPTION="SVG-based theme engine for Qt6"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.3"
TERMUX_PKG_SRCURL="https://github.com/tsujan/Kvantum/releases/download/V${TERMUX_PKG_VERSION}/Kvantum-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d9e4eca0c0a760a032c7c26c1baffa1409eb2ad6f1c05d341109fa5751a3f041
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="kf6-kwindowsystem, libc++, libx11, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools-cross-tools"

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/Kvantum"
}

termux_step_post_make_install() {
	local _QT6_STYLES_DIR=$TERMUX_PREFIX/lib/qt6/plugins/styles
	mkdir -p "$_QT6_STYLES_DIR"
	mv $TERMUX_PREFIX/opt/qt6/cross/lib/qt6/plugins/styles/libkvantum.so $_QT6_STYLES_DIR
}
