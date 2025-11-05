TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="LXQt Image Viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lximage-qt/releases/download/${TERMUX_PKG_VERSION}/lximage-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9376d492945917a5ee2ec6a69bb8f6aeadf89d0f14c38d73a2eac5407b34b641
TERMUX_PKG_DEPENDS="glib, libc++, libexif, libfm-qt, libx11, libxfixes, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
