TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="A lightweight Qt terminal emulator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/qterminal/releases/download/${TERMUX_PKG_VERSION}/qterminal-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a65e788645bc694ede5d89de4118ee88443e0d6cbc388b0ce50d5c5d07b1213c
TERMUX_PKG_DEPENDS="layer-shell-qt, libc++, libx11, qt6-qtbase, qtermwidget"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"
