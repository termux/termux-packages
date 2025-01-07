TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="A terminal emulator widget for Qt 5"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/qtermwidget/releases/download/${TERMUX_PKG_VERSION}/qtermwidget-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=26ecb2c3a38de10db3b5ae24970957a33520f7742e3ae1ff93d345ded2be8e4b
TERMUX_PKG_DEPENDS="libc++, libx11, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"
