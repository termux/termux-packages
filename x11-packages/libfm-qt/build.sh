TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Library providing components to build desktop file managers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.1"
TERMUX_PKG_SRCURL="https://github.com/lxqt/libfm-qt/releases/download/${TERMUX_PKG_VERSION}/libfm-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c582abdeb3e86ad7e3cedc60a4b6c697557b6f6a834e9d58c3743e843e519d25
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, glib, libxcb, libexif, lxqt-menu-data, menu-cache"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
