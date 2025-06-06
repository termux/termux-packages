TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="A lightweight Qt terminal emulator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/lxqt/qterminal/releases/download/${TERMUX_PKG_VERSION}/qterminal-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=0cd38c3408bbaf4737a0276cf3d64b4c987716f0ef1f1eb8e9c1485e0c08f5d2
TERMUX_PKG_DEPENDS="layer-shell-qt, libc++, libx11, qt6-qtbase, qtermwidget"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
