TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="A terminal emulator widget for Qt 5"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/qtermwidget/releases/download/${TERMUX_PKG_VERSION}/qtermwidget-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4d29fec9c3d1974278bf64f2daf8e879b3696a29d2cc35f23894340be64c51ff
TERMUX_PKG_DEPENDS="libc++, libx11, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
