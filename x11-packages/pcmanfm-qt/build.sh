TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="PCManFM-Qt is the file manager of LXQt"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/pcmanfm-qt/releases/download/${TERMUX_PKG_VERSION}/pcmanfm-qt-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=30ab4cc0f36aedd3f454cec2468d7b8a5820f12de1dd9e69d2e65d7299716d09
TERMUX_PKG_DEPENDS="desktop-file-utils, glib, layer-shell-qt, libc++, libfm-qt, libxcb, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
