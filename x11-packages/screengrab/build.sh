TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="Cross-platform tool for creating screenshots"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/screengrab/releases/download/${TERMUX_PKG_VERSION}/screengrab-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=30ad0428688595eb09ca684133c1bb1b02c4affae302791c4d2eb7990f6ccee7
TERMUX_PKG_DEPENDS="kf6-kwindowsystem, layer-shell-qt, libc++, libx11, libxcb, libqtxdg, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
